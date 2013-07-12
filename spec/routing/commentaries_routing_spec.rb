require "spec_helper"

describe CommentariesController do
  describe "routing" do

    it "routes to #index" do
      get("/commentaries").should route_to("commentaries#index")
    end

    it "routes to #new" do
      get("/commentaries/new").should route_to("commentaries#new")
    end

    it "routes to #show" do
      get("/commentaries/1").should route_to("commentaries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/commentaries/1/edit").should route_to("commentaries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/commentaries").should route_to("commentaries#create")
    end

    it "routes to #update" do
      put("/commentaries/1").should route_to("commentaries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/commentaries/1").should route_to("commentaries#destroy", :id => "1")
    end

  end
end
