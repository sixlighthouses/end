class NotesController < ApplicationController
  before_action :set_todo, except: [ :index ]
  before_action :set_note, only: [ :show, :edit, :update, :destroy ]

  # GET /notes - Show all notes from all todos
  def index
    @notes = Note.includes(:todo).order(created_at: :desc)
  end

  # GET /todos/:todo_id/notes/new
  def new
    # check that @todo is set and if not create a standalone note (not linked to a todo)
    # this is handled in set_todo
    if @todo.nil?
      @note = Note.new
      return
    end
    @note = @todo.notes.build
  end

  # POST /todos/:todo_id/notes
  def create
    if @todo.nil?
      @note = Note.new(note_params)
    else
      @note = @todo.notes.build(note_params)
    end

    respond_to do |format|
      if @note.save
        format.html { redirect_to [ @todo, @note ], notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: [ @todo, @note ] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /todos/:todo_id/notes/:id
  def show
  end

  # GET /todos/:todo_id/notes/:id/edit
  def edit
  end

  # PATCH/PUT /todos/:todo_id/notes/:id
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to [ @todo, @note ], notice: "Note was successfully updated." }
        format.json { render :show, status: :ok, location: [ @todo, @note ] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/:todo_id/notes/:id
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to @todo, notice: "Note was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:todo_id]) if params[:todo_id].present?
  rescue ActiveRecord::RecordNotFound
    redirect_to todos_path, alert: "Todo not found."
    false
  end

  def set_note
    if @todo.nil?
      @note = Note.find(params[:id])
      return
    end
    @note = @todo.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
