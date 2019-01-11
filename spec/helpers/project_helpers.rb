module Helpers
  module ProjectHelpers
    def add_collection_to_project(id, name)
      wait_for_xhr
      fill_in 'keywords', with: id
      wait_for_xhr
      expect(page).to have_content(name)
      expect(page).to have_css('#collection-results .panel-list-item', count: 1)
      first_collection_result.click_link 'Add collection to the current project'
    end

    def reset_project
      page.execute_script('edsc.models.page.current.project.collections([])')
      page.execute_script('edsc.models.page.current.project.collections()') # Read it back out to ensure it was applied
      page.execute_script('edsc.models.page.current.project.searchGranulesCollection(null)')
    end

    def project_collection_ids
      page.evaluate_script('edsc.models.page.current.project.collections().map(function(ds){return ds.collection.dataset_id;})')
    end

    def click_save_project_name
      page.execute_script('$(".save-workspace-name").click()')
      wait_for_xhr
    end

    def query
      URI.parse(page.current_url).query
    end

    def project_id
      query[query_re, 1].to_i
    end

    def create_project(user_id, path = '/search/collections?p=!C179003030-ORNL_DAAC', name = 'Test Project')
      user = User.find_or_create_by(echo_id: user_id)
      project = Project.new
      project.path = path
      project.name = name
      project.user_id = user.id
      project.save!
      project
    end

    def visit_project(user_id, name = 'Test Project')
      project = create_project(user_id, name: name)
      
      visit project_path(project)
    end
  end
end
