require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "does not require login" do
      session[:id] = nil
      get :new

      expect(flash[:error]).to be_nil
      expect(response).not_to redirect_to(registration_path)
    end

    it "renders the new template" do
      get :new

      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "valid user params" do
      before :each do
        @user = create(:user)

        post :create, session: { username: @user.username, password: @user.password }
      end

      it "sets the user" do
        expect(assigns(:user)).to eq @user
      end

      it "sets session[:id] to the user's id" do
        expect(session[:id]).to eq @user.id
      end

      it "updates the flash[:messages] to include :successful_login" do
        expect(flash[:messages]).to include { :successful_login }
      end

      it "redirects to the user's homepage" do
        expect(response).to redirect_to root_path(@user.id)
        expect(response).to have_http_status(302)
      end
    end

    context "invalid user params" do
      before :each do
        @user = create(:user)
      end

      it "invalid password renders the page with error message" do
        post :create, session: { username: @user.username, password: "invalid" }

        expect(response).to redirect_to(registration_path)
        expect(flash[:errors]).to include { :login_error }
      end

      it "invalid username renders the page with error message" do
        post :create, session: { username: "invalid_user", password: @user.password }

        expect(response).to redirect_to(registration_path)
        expect(flash[:errors]).to include { :login_error }
      end
    end
  end

  describe "DELETE #destroy" do
    before :each do
      @user = create(:user)
      post :create, session: {username: @user.username, password: @user.password}
      delete :destroy
    end

    it "sets session user_id to nil" do
      expect(session[:id]).to be nil
    end

    it "redirects to the root path" do
      expect(response).to redirect_to root_path
    end
  end
end
