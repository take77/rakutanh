class NotesController < ApplicationController

  def new
    @note = Note.new
    @note.note_items.build
    @subject = Subject.new
    @affiliation = Affiliation.new
  end

  def create

    if params[:checkbox_return] == "1"

      affiliation = Affiliation.create(affiliation_create_params)

      if affiliation.save
        new_affiliation = affiliation
      else
        new_affiliation = affiliation_already_exists(affiliation)
      end

    else
      new_affiliation = Affiliation.find(current_user.affiliation_id)
    end

    subject = Subject.new(subject_create_params)
    subject.affiliation_id = new_affiliation.id
    subject.save

    if subject.save
      new_subject = subject
    else
      new_subject = subject_already_exists(subject)
    end

    note = Note.new(note_create_params)
    note.affiliation_id = new_affiliation.id
    note.subject_id = new_subject.id
    note.user_id = current_user.id
    note.save
  end

  def show
    @note = Note.find(params[:id])
    @note_items = NoteItem.where(note_id: @note.id)
    @note_comment = NoteComment.new
    note_comments = NoteComment.where(note_id: @note.id)
    @note_parent_comments = note_comments.where(status: 0)
    @note_child_comments = note_comments.where(status: 1)
    notr = @note
    @clip = clip_check(note, clip = 0)
  end

  def affiliation_already_exists(affiliation)
    affiliation = Affiliation.find_by(:college => affiliation.college, :department => affiliation.department, :course => affiliation.course)
  end

  def subject_already_exists(subject)
    subject = Subject.find_by(:name => subject.name, :professor => subject.professor, :affiliation_id => subject.affiliation_id)
  end

  def clip_check(note, a_clip)
    note_id = note.id
    feed_content_id = FeedContent.find_by(content_id: note_id).id
    if Clip.find_by(feed_content_id: feed_content_id)
      a_clip = Clip.find_by(feed_content_id: feed_content_id).id
    else
      a_clip = 0
    end
  end

  private
  def affiliation_create_params
    params.require(:affiliation).permit(:college, :department, :course)
  end

  def subject_create_params
    params.require(:subject).permit(:name, :professor, :affiliation_id)
  end

  def note_create_params
    params.require(:note).permit(:title, :taken_date, :explanation, :affiliation_id, :subject_id,
        note_items_attributes:[:note_file])
  end

end
