class TodosController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show, :update_positions, :new, :edit, :destroy ]
  skip_before_action :verify_authenticity_token, only: [ :update_positions ]
  before_action :set_todo, only: %i[ show edit update destroy ]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
    @sort = params[:sort] || "position"
    @direction = params[:direction] || "asc"
    @todo = Todo.new

    # Debug output
    Rails.logger.debug "Sort: #{@sort}, Direction: #{@direction}"

    # Only allow safe values for direction
    safe_direction = %w[asc desc].include?(@direction) ? @direction : "asc"

    case @sort
    when "due_date"
      @todos = @todos.order(Arel.sql("due_date #{safe_direction} NULLS LAST"))
    else
      @todos = @todos.order(:position)
    end
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)
    # Auto-assign position as the highest current position + 1
    last_position = Todo.maximum(:position) || 0
    @todo.position = last_position + 1

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_path, notice: "Todo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def update_positions
    positions = params[:positions]

    # Parse JSON if it's a string
    if positions.is_a?(String)
      positions = JSON.parse(positions) rescue {}
    end

    if positions.is_a?(Hash)
      Todo.transaction do
        positions.each do |todo_id, new_position|
          todo = Todo.find(todo_id)
          todo.update!(position: new_position.to_i)
        end
      end

      render json: { success: true }
    else
      render json: { success: false, error: "Invalid positions format" }, status: :unprocessable_entity
    end
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params.expect(todo: [ :name, :description, :position, :due_date, :completed ])
  end
end
