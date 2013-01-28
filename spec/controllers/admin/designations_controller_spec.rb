require 'spec_helper'
describe Admin::DesignationsController do
  describe "GET index" do
    it "assigns @designations sorted by name" do
      TaxonConcept.delete_all
      ChangeType.delete_all
      SpeciesListing.delete_all
      Designation.delete_all
      designation1 = create(:designation, :name => 'BB', :taxonomy => create(:taxonomy))
      designation2 = create(:designation, :name => 'AA', :taxonomy => create(:taxonomy))
      get :index
      assigns(:designations).should eq([designation2, designation1])
    end
    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "XHR POST create" do
    it "renders create when successful" do
      xhr :post, :create, designation: build_attributes(:designation)
      response.should render_template("create")
    end
    it "renders new when not successful" do
      xhr :post, :create, designation: {}
      response.should render_template("new")
    end
  end

  describe "XHR PUT update" do
    let(:designation){ create(:designation) }
    it "responds with 200 when successful" do
      xhr :put, :update, :format => 'json', :id => designation.id, :designation => { :name => 'ZZ' }
      response.should be_success
    end
    it "responds with json when not successful" do
      xhr :put, :update, :format => 'json', :id => designation.id, :designation => { :name => nil }
      JSON.parse(response.body).should include('errors')
    end
  end

  describe "DELETE destroy" do
    let(:designation){ create(:designation) }
    it "redirects after delete" do
      delete :destroy, :id => designation.id
      response.should redirect_to(admin_designations_url)
    end
  end

end
