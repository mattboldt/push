class Github

  require 'octokit'

    # get file contents
    def load_file
      @file = open(@post.github_url) { |f| f.read }
    end

    # GitHub Repo Connectivity
    def github_auth(user)
      # grab token from OAuth in (user) authentications table
      token = user.authentications.find(:first, :conditions => { :provider => 'github' }).token
      # init Octokit Client w/ OAuth
      @@github = Octokit::Client.new(:access_token => token)
      # current user's username from (user) authentications table
      @@username = user.authentications.find(:first, :conditions => { :provider => 'github' }).username

      # set static repo name
      @@repo = @@username + "/" + user.git_repo_name
      # we'll always be on the master branch
      @@ref = 'heads/master'
    end

    def create_github_repo(user, repo_name)
      github_auth(user)
      repo_name ||= "pushblog"
      post_params = {}
      create_repo = @@github.create_repo(repo_name, :description => "A new repo", :auto_init => true)
      return create_repo.to_json
      post_params['git_file_name'] = "README.md"
      post_params['git_commit_message'] = "1st commit"
      post_params['body'] = "Here's the README of your brand new Push Blog!"
      # commit!
      commit_to_github(post_params)
    end

    # # create a file on github
    # def create_github_repo_file(post_params)
    #   # commit
    #   commit_to_github(@repo, post_params)
    # end

    # # update a file on github
    # def update_github_repo_file(post_params)
    #   # commit
    #   commit_to_github(@repo, post_params)
    # end

    # delete a file on github
    def delete_github_repo_file
      # commit
      commit_to_github(@repo, post_params)
    end

    def pull_from_github(post_params)
      Octokit.contents("mattboldt/gitblog", :path => '2014/02/25/organizing-css-and-sass-in-rails.md').to_json.to_json
    end

    def commit_to_github(post_params)
      # if file name changes, will create a new file in git.
      file_name = post_params["git_file_name"]
      # set default commit message, unless there's one from the form
      commit_message = post_params['git_commit_message'] || "New commit."
      # Base64 encode your content, and create a blob.
      blob_sha = @@github.create_blob(@@repo, Base64.encode64(post_params['body']), "base64")

      # grab latest commit of the repo, store its SHA hash
      sha_latest_commit = @@github.ref(@@repo, @@ref).object.sha
      # find & store SHA hash for the tree the heads/master (@@ref) commit points to
      sha_base_tree = @@github.commit(@@repo, sha_latest_commit).commit.tree.sha
      # Make a new git tree w/ the repo, file name, and content blob.
      sha_new_tree = @@github.create_tree(@@repo,
                        [{
                          :path => file_name,
                          :mode => "100644",
                          :type => "blob",
                          :sha => blob_sha
                        }],
                        # set base tree to latest commit tree
                        {:base_tree => sha_base_tree }
                      ).sha

      # create the commit
      sha_new_commit = @@github.create_commit(@@repo, commit_message, sha_new_tree, sha_latest_commit).sha
      updated_ref = @@github.update_ref(@@repo, @@ref, sha_new_commit)
      return @@github.commit(@@repo, sha_latest_commit)
    end

    # removed due to potential API limitation. Needs to be cached in redis.
    # def history(current_user, user_id)
    #   # grab token from OAuth in (user) authentications table
    #   token = current_user.authentications.find(:first, :conditions => { :provider => 'github' }).token
    #   # init Octokit Client w/ OAuth
    #   octokit = Octokit::Client.new(:access_token => token)
    #   octokit.commits(user_id + "/gitblog/2014/02/25/organizing-css-and-sass-in-rails.md")
    # end

  end


  # referrence: http://mattgreensmith.net/2013/08/08/commit-directly-to-github-via-api-with-octokit/