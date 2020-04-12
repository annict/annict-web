# frozen_string_literal: true

describe "DELETE /db/organizations/:id", type: :request do
  context "user does not sign in" do
    let!(:organization) { create(:organization, :not_deleted) }

    it "user can not access this page" do
      delete "/db/organizations/#{organization.id}"
      organization.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("ログインしてください")

      expect(organization.deleted?).to eq(false)
    end
  end

  context "user who is not editor signs in" do
    let!(:user) { create(:registered_user) }
    let!(:organization) { create(:organization, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it "user can not access" do
      delete "/db/organizations/#{organization.id}"
      organization.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("アクセスできません")

      expect(organization.deleted?).to eq(false)
    end
  end

  context "user who is editor signs in" do
    let!(:user) { create(:registered_user, :with_editor_role) }
    let!(:organization) { create(:organization, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it "user can not access" do
      delete "/db/organizations/#{organization.id}"
      organization.reload

      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq("アクセスできません")

      expect(organization.deleted?).to eq(false)
    end
  end

  context "user who is admin signs in" do
    let!(:user) { create(:registered_user, :with_admin_role) }
    let!(:organization) { create(:organization, :not_deleted) }

    before do
      login_as(user, scope: :user)
    end

    it "user can delete organization softly" do
      expect(organization.deleted?).to eq(false)

      delete "/db/organizations/#{organization.id}"
      organization.reload

      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq("削除しました")

      expect(organization.deleted?).to eq(true)
    end
  end
end
