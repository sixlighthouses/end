class NotesController < ApplicationController
  before_action :set_todo
  before_action :set_note, only: [ :show, :edit, :update, :destroy ]

  # GET /todos/:todo_id/notes/new
  def new
    @note = @todo.notes.build
  end

  # POST /todos/:todo_id/notes
  def create
    @note = @todo.notes.build(note_params)

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
    @todo = Todo.find(params[:todo_id])
  end

  def set_note
    @note = @todo.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
