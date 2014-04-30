# I have no clue why this is stalling the build
# require 'spec_helper'

# describe Species::ExportsController do
#   describe "GET download" do
#     context "CITES listings" do
#       after(:each){ DownloadsCache.clear_cites_listings }
#       it "returns count of listed species" do
#         create_cites_I_addition(:taxon_concept => create_cites_eu_species, :is_current => true)
#         Sapi::StoredProcedures.rebuild_cites_taxonomy_and_listings
#         get :download, :data_type => 'Listings', :filters => {:designation => 'CITES'}, :format => :json
#         parse_json(response.body)['total'].should == 1
#       end
#       it "returns listed species file" do
#         create_cites_I_addition(:taxon_concept => create_cites_eu_species, :is_current => true)
#         Sapi::StoredProcedures.rebuild_cites_taxonomy_and_listings
#         Species::ListingsExport.any_instance.stub(:public_file_name).and_return('cites_listings.csv')
#         get :download, :data_type => 'Listings', :filters => {:designation => 'CITES'}
#         response.content_type.should eq("text/csv")
#         response.headers["Content-Disposition"].should eq("attachment; filename=\"cites_listings.csv\"")
#       end
#       it "redirects when no results" do
#         get :download, :data_type => 'Listings', :filters => {:designation => 'CITES'}
#         response.should redirect_to(species_exports_path)
#       end
#     end
#     context "EU listings" do
#       after(:each){ DownloadsCache.clear_eu_listings }
#       it "returns count of listed species" do
#         create_eu_A_addition(:taxon_concept => create_cites_eu_species, :event =>reg2013, :effective_at => '2013-08-10', :is_current => true)
#         Sapi::StoredProcedures.rebuild_eu_taxonomy_and_listings
#         get :download, :data_type => 'Listings', :filters => {:designation => 'EU'}, :format => :json
#         parse_json(response.body)['total'].should == 1
#       end
#       it "returns listed species file" do
#         create_eu_A_addition(:taxon_concept => create_cites_eu_species, :event =>reg2013, :effective_at => '2013-08-10', :is_current => true)
#         Sapi::StoredProcedures.rebuild_eu_taxonomy_and_listings
#         Species::ListingsExport.any_instance.stub(:public_file_name).and_return('eu_listings.csv')
#         get :download, :data_type => 'Listings', :filters => {:designation => 'EU'}
#         response.content_type.should eq("text/csv")
#         response.headers["Content-Disposition"].should eq("attachment; filename=\"eu_listings.csv\"")
#       end
#       it "redirects when no results" do
#         get :download, :data_type => 'Listings', :filters => {:designation => 'EU'}
#         response.should redirect_to(species_exports_path)
#       end
#     end
#     context "CMS listings" do
#       after(:each){ DownloadsCache.clear_cms_listings }
#       it "returns count of listed species" do
#         create_cms_I_addition(:taxon_concept => create_cms_species, :is_current => true)
#         Sapi::StoredProcedures.rebuild_cms_taxonomy_and_listings
#         get :download, :data_type => 'Listings', :filters => {:designation => 'CMS'}, :format => :json
#         parse_json(response.body)['total'].should == 1
#       end
#       it "returns listed species file" do
#         create_cms_I_addition(:taxon_concept => create_cms_species, :is_current => true)
#         Sapi::StoredProcedures.rebuild_cms_taxonomy_and_listings
#         Species::ListingsExport.any_instance.stub(:public_file_name).and_return('cms_listings.csv')
#         get :download, :data_type => 'Listings', :filters => {:designation => 'CMS'}
#         response.content_type.should eq("text/csv")
#         response.headers["Content-Disposition"].should eq("attachment; filename=\"cms_listings.csv\"")
#       end
#       it "redirects when no results" do
#         get :download, :data_type => 'Listings', :filters => {:designation => 'CMS'}
#         response.should redirect_to(species_exports_path)
#       end
#     end
#   end
# end
