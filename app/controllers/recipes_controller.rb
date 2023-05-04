class RecipesController < ApplicationController

    def index
        user = User.find_by(id: session[:user_id])
        if user
            render json: Recipe.all, only: [:id, :title, :instructions, :minutes_to_complete], include: [:user], status: :created
        else
            render json: {errors: ["unauthorized"]}, status: :unauthorized
        end
    end

    def create
        user = User.find_by(id: session[:user_id])
        if user
            recipe = user.recipes.build(recipe_params)
            if recipe.valid?
                recipe.save
                render json: recipe, only: [:id, :title, :instructions, :minutes_to_complete], include: [:user], status: :created
            else
                render json: {errors: recipe.errors.full_messages}, status: :unprocessable_entity
            end
        else
            render json: {errors: ["unauthorized"]}, status: :unauthorized
        end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

end
