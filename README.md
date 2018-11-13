# Lynda - Ruby on Rails 5 Essential Training

## Main Points

- using mysql database
- rendering a different template from the controller
- redirecting from the controller
- using a local variable in a html.erb template
- full links code
- links with params
- creating database migrations with the up and down
- the different table column types (binary, boolean, string etc.)
- migrating down to database 0
- rails db:migrate:status to see which migrations have been run
- rails db:migrate VERSION=20181106105241 to migrate to a specific migration point
- fixing bugs in migrations
- using the lambda syntax to create scopes
- table associations, 1:1, 1:M, M:N
- Using a rich join table
- has_many :through
- using the ternary operator to show boolean options 

```
<td><%= @subject.visible ? 'true' : 'false' %></td>
```

- using a different layout
- giving pages a page title
- text helpers: word wrap, simple format, truncate, pluralize, truncate words, highlight, excerpt
- number helpers: number to currency, number to percentage, number with precision or number to rounded, number with delimiter or number to delimited, number to human, number to human size, number to phone
- date and time helpers: minute, hour, day, week, month, year
- custom boolean helper
- using content_tags
- HTML escape methods
- sanitize helpers
- using different css files for different layouts
- javascript helpers and javascript_tag
- escaping javascript
- using image tags
- using images in css
- form helpers
- textarea col/row size: '40x5'
- select option tag, list items, dropdown list
- date and time form helpers
- css of error fields
- error helpers
- validation methods
- email regex validation
- custom validations
- cookies and sessions usage
- log files, developers set a task to automatically backup and clear them
- sorting with multiple attributes: scope :sorted, lambda { order('last_name ASC, first_name ASC') }
- link_to_unless_current
- using the acts as list gem
- list of top gems

## Main Course

- I'm using sqlite3
- in terminal rails new simple_cms -d mysql
- mysql -u root -p
- enter password
- CREATE DATABASE simple_cms_development;
- CREATE DATABASE simple_cms_test;
- GRANT ALL PRIVILEGES ON simple_cms_development.* TO 'rails_user'@'localhost' IDENTIFIED BY 'secretpassword';
- GRANT ALL PRIVILEGES ON simple_cms_test.* TO 'rails_user'@'localhost' IDENTIFIED BY 'secretpassword';
- exit;
- in database.yml update the default to be:

```
username: rails_user
password: secretpassword
```

- in terminal: rails db:schema:dump (if it connects and does nothing, means the connection worked, and it created a schema.rb file)
- rails g controller Demo index
- ** rendering a templage **

```
def index
	render('hello')
end
```

- ** redirecting actions

```
	def other_hello
		redirect_to(:action => 'hello')
	end
	def lynda
		redirect_to('http://lynda.com')
	end
```

- using a local variable in a template

```
<% target = 'world' %>
<%= "hello #{target}" %>
```

- full links code

```
<%= link_to('Hello', {:controller => 'demo', :action => 'hello'}) %>
```

- links with params

```
<%= link_to('With params', {:action => 'hello', :id => 20, :page => 5}) %>
```

- to read the params, in the demo controller add the instance variables


```
  def hello
    @id = params['id']
    @page = params[:page]
  end
```

- and on the hello page, to display the values

```
<p>
	The Id is <%= @id %>
</p> 
<p>
	The Page is <%= @page %>
</p>
```

### Databases 

- rails g migration DoNothingYet
- update the migration file

```
class DoNothingYet < ActiveRecord::Migration[5.2]
  def up
  end

  def down
  end
end

```

- rails g model User
- change the migration file to be

```
class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_table :users do |t|
      t.column "first_name", :string, :limit => 25
      t.string "last_name", :limit => 50
      t.string "email", :default => '', :null => false
      t.string "password", :limit => 40

      t.timestamps
      # t.datetime "created_at"
      # t.datetime "updated_at"
    end
  end

  def down
    drop_table :users
  end
end
```

- the different database table column types are:

```
binary, boolean, date, datetime, decimal, float, integer, string, text, time
```

- the different options for the columns are

```
:limit => size
:default => value
:null => true/false
:precision => number
:scale => number
```

- rails db:migrate
- rails db:migrate VERSION=0
- rails db:migrate:status
- rails db:migrate VERSION=20181106105241
- rails db:migrate:up VERSION=20181106105241
- rails db:migrate:down VERSION=20181106105241
- rails db:migrate:redo VERSION=20181106105241
- ** Table migration methods **

```
create_table(table, options) do |t|
	...colums...
end
drop_table(table)
rename_table(table, new_name)
```

- ** Column migration methods **

```
add_column(table, column, type, options)
remove_column(table, column)
rename_column(table, column, new_name)
change_column(table, column, type, options)
```

- ** Index migration methods **

```
add_index(table, column, options)
remove_index(table, column)
```

- ** Index migration method options **

```
:unique => true/false
:name => "your_custom_name"
```

- rails g migration AlterUsers
- update the migration file to be: the down method has to be the opposite AND in reverse order

```
class AlterUsers < ActiveRecord::Migration[5.2]
  def up
    rename_table("users", "admin_users")
    add_column("admin_users", "username", :string, :limit => 25, :after => "email")
    change_column("admin_users", "email", :string, :limit => 100)
    rename_column("admin_users", "password", "hashed_password")
    puts "*** Adding an index ***"
    add_index("admin_users", "username")
  end

  def down
    remove_index("admin_users", "username")    
    rename_column("admin_users", "hashed_password", "password")
    change_column("admin_users", "email", :string, :default => '', :null => false)
    remove_column("admin_users", "username")
    rename_table("admin_users", "users")
  end
end
```

- rails db:migrate
- rails db:migrate VERSION=0 (to see all migrations run smoothly)

### FIXING MIGRATION BUGS

- rails db:migrate VERSION=0 to go to empty database state
- change the column in one migration

```
rename_column("admin_users", "broken", "hashed_password")
```

- rails db:migrate, theres an error cuz broken doesn't exist
- fix the error, and run rails db:migrate again
- another error, cuz the table exists
- run rails db:migrate VERSION=0 to go back to a clean slate, but another error cuz its trying to delete a table that doesn't exist
- ** to fix being stuck in that state, comment out the lines of the migration that have run already when trying to get to the 'up' state**, 
- run rails db:migrate to get to a fully migrated up state
- then uncomment the code
- run rails db:migrate VERSION=0 to clean database
- run rails db:migrate to get it all running properly

### creating the actual table for the app

- the concept is: A subject has many pages and a page has many sections
- ** ALWAYS INDEX FOREIGN KEYS **
- MODELS: Subject, Page, Section
- rails g model Subject name:string position:integer visible:boolean (update the migrate for visible:boolean, :default => false)
- rails g model Page subject_id:integer:index name permalink:string:index position:integer visible:boolean
- rails g model Section page_id:integer:index name position:integer visible:boolean content_type content:text
- rails db:migrate
- rails db:migrate VERSION=0 to make sure the drop works
- ** Since we renamed the users database to admin_user, wee need to change the model **
- 2 ways to do it, 1) add this line to the user.rb

```
class User < ApplicationRecord
  self.table_name = 'admin_users'
end
```

- or rename the file to match

```
admin_user.rb
class AdminUser < ApplicationRecord
  # self.table_name = 'admin_users'
end
```

### Constructing queries

```
Subject.find(2)
Subject.find_by_id(2)
Subject.find_by_name("First Subject")
Subject.all
Subject.first
Subject.last
Subject.where(:visible => true)
subjects = Subject.where(:visible => true)
subjects = Subject.where('visible = ture')
subjects = Subject.where(["visible = ?", true])
subjects = Subject.where(:position => 1, :visible = true)
subjects = Subject.where(:visible => true).order("position ASC").limit(1).offset(1)
```

### named scopes

- using the lambda syntax

```
scope :active, lambda {where(:active => true)}
scope :active, -> {where(:active => true)}
def self.active
	where(:active => true)
end
Customer.active
```

- passing it a parameter

```
scopre :with_content_type, lambda {|ctype| where(:content_type => ctype)}

def self.with_content_type(ctype)
	where(:content_type => ctype)
end

Section.with_content_type('html')
```

- using scopes in our app

```
class Subject < ApplicationRecord
  scope :visible, lambda { where(:visible => true) }
  scope :invisible, lambda { where(:invisible => false) }
  scope :sorted, lambda { order("position ASC") }
  scope :newest_first, lambda { order("created_at DESC") }
  scope :search, lambda {|query| where(["name LIKE ?", "%#{query}%"])}
end
```

- in rails c

```
Subject.visible
Subject.invisible
Subject.search("Initial")
```

### Relationship types between database

- one to one (one teacher to one classroom, classroom has one teacher, teacher belongs to classroom)

```
Classroom has_one :teacher
Teacher belongs_to :classroom
```

- one to many (teacher has many courses, course belongs to teacher)

```
Teacher has_many :courses
Course belongs_to :teacher
```

- many to many (uses a join table holding 2 foreign keys, Course has many students and belongs to many students, Student has many course and belongs to many courses, )

```
Course has_and_belongs_to_many :students
Student has_and_belongs_to_many :courses
```

- adding it to the project
- in subject.rb

```
has_one :page
```

- in page.rb
- in rails c

```
subject = Subject.find(1)
subject.page
```

- in subject.rb

```
has_one :pages
```

- methods

```
subject.pages.count
subject.pages.size (same as count without doing a sql search)
subject.pages.empty?
subject.pages.delete(second_page)
subject.pages.clear
```

- in page.rb

```
has_many :sections
```

- in section.rb

```
belongs_to :page
```

- ** belongs to presence validation **

```
starting in 5.0 a model that belongs to another model, automatically must exist when being saved
```

- a way to avoid this is in the model, like in page.rb

```
belongs_to :subject, { :optional => true} (default is false)
```

- ** many to many associations: simple **
- creating the joining table, rails convention is:

```
first_table + _ + second_table in alphabetical order
collaborators_projects
blog_posts_categories
admin_users_pages
```

- rails g migration CreateAdminUsersPagesJoin

```
class CreateAdminUsersPagesJoin < ActiveRecord::Migration[5.2]
  def up
    create_table :admin_users_pages, :id => false do |t|
      t.integer "admin_user_id"
      t.integer "page_id"
    end
    add_index("admin_users_pages", ["admin_user_id", "page_id"])
  end

  def down
    drop_table :admin_users_pages
  end
end
```

- we added, id = false because we don't need a primary key
- rails db:migrate
- in page.rb

```
has_and_belongs_to_many :admin_users
has_and_belongs_to_many :admin_users, :join_table => 'pages_admin_users' (in case we didnt follow rails convention of alphabetical, but since we did, we don't need to tell it what table we are using)
```

- in admin_user.rb

```
has_and_belongs_to_many :pages
```

### Using a rich join table

- rails g model SectionEdit

```
class CreateSectionEdits < ActiveRecord::Migration[5.2]
  def up
    create_table :section_edits do |t|
      t.integer "admin_user_id"
      t.integer "section_id"
      t.string "summary"
      t.timestamps
    end
    add_index("section_edits", ["admin_user_id", "section_id"])
  end

  def down
    drop_table :section_edits
  end
end

```

- rails db:migrate
- in admin_user


```
has_many :section_edits
```

- in section_edit

```
class SectionEdit < ApplicationRecord
  belongs_to :admin_user
  belongs_to :section
end

```

- in section.rb

```
has_many :section_edits
```

### Using has_many :through

- update admin_user.rb

```
class AdminUser < ApplicationRecord
  # self.table_name = 'admin_users'
  has_and_belongs_to_many :pages
  has_many :section_edits
  has_many :sections, :through => :section_edits
end

```

- update section.rb

```
class Section < ApplicationRecord
  belongs_to :page
  has_many :section_edits
  has_many :admin_users, :through => :section_edits
end

```

- in rails c: 

```
a = AdminUser.first
a.section_edits
a.sections
s = Section.first
```

### CRUD

- rails g controller Subjects index show new edit delete
- update subjects_controller with edit and update
- if you want to use a 'delete' page then in routes do:

```
resources :subjects do
	member do
		get :delete
	end
end
```

- update routes

```
  resources :subjects do
    member do
      get :delete
    end
  end
```

### Form basics

- including the full path in the form_for

```
<%= form_for(@subject, :url => subjects_path, :method => 'post') do |f| %>
<%= form_for(@subject, :url => subject_path(@subject), :method => 'patch') do |f| %>
<%= form_for(@subject, :url => subject_path(@subject), :method => 'delete') do |f| %>
```

- rails g controller Pages index show new edit delete
- rails g controller Sections index show new edit delete

### Layouts

- using a different layout
- in views/layouts create: admin.html.erb
- copy the code from application.html.erb
- in subjects controller, uptop add


```
layout 'admin'
```

- ** page title **
- in the layout replace the title with

```
<title>Simple CMS: <%= @page_title || 'Admin Area' %></title>
```

- and on each page add

```
<% @page_title = "All Subjects" %>
```

- example of number helpers


```
number_to_currency(34.5)
number_to_currency(34.5, precision: 0, unit: 'kr', format: '%n %u')
number_to_percentage(34.5, precision: 1, seperator: ',')
number_with_precision(34.56789, precision: 6)
number_to_human(123456789, precision: 5) = 123.46 Million
number_to_human_size(1234567, precision: 2) = 1.2 MB {for file sizes}
number_to_phone(1234567890, area_code: true, delimiter: ' ', country_code: 1, extension: '321') = +1 (123) 456 7890 x 321
```

- date and time helpers

```
Time.now + 30.days - 23.minutes
30.days.ago
30.days.from_now
beginning_of_day end_of_day
beginning_of_week end_of_week
beginning_of_month end_of_month
beginning_of_year end_of_year
yesterday tomorrow
last_week next_week
last_month next_month
last_year next_year
Time.now.last_year.end_of_month.beginning_of_day
Time.now.strftime("%B %d, %Y %H:%M")
Time.now.to_s(:long)
```

### Custom helpers

- in application_helper

```
  def status_tag(boolean, options={})
    options[:true_text] ||= ''
    options[:false_text] ||= ''
    if boolean
      content_tag(:span, options[:true_text], class: 'status true')
    else
      content_tag(:span, options[:false_text], class: 'status false')
    end
  end
```

- then to use it

```
<td class="center"><%= status_tag(subject.visible) %></td>
```

- in the css

```
span.status {
	display: block;
	width: 10px;
	height: 10px;
	margin: 0.25em auto;
	padding: 0;
	border: 1px solid #000;
	&.true {
		background: green;
		color: green;
	}
	&.false {
		background: red;
		color: red;
	}
}
```

-  using escape methods

```
html_escape(), h() {how it used to be, every html is automatically escaped}
raw() if you don't want it escaped - raw escapes it once
<% evil_string = "<script>alert('gotcha');</script>" %>
<%= raw evil_string %>
html_safe() if you dont want it escaped - html_safe escapes it everywhere in the page
<% evil_string = "<script>alert('gotcha');</script>" %>
<%= evil_string.html_safe %>
strip_links(html)
sanitize(html, options)
sanitize(@subject.content, tags: ['p', 'br', 'strong', 'em'], attributes: ['id', 'class', 'style'])
``` 

### asset pipeline

- using a different stylesheet for a different layout
- create: admin.scss and copy the application.scss code
- in initializers/assets.rb uncomment

```
Rails.application.config.assets.precompile += %w( admin.scss )
```

- in layouts/admin change the style tag

```
<%= stylesheet_link_tag    'admin', media: 'all', 'data-turbolinks-track': 'reload' %>
```

- restart server
- ** javascript helpers**

```
<%= javascript_tag("alert('Are you sure?');") %>
<%= javascript_tag do %>
	alert('Are you sure?');
<% end %>
```

- **to escape javascript**

```
escape_javascript(), j()
<% text = "'); alert('Gotcha!" %>
<%= javascript_tag("alert('You said: #{j(text)}');") %>
```

### Images

- using image tag

```
<%= image_tag('plus_sign.png', size: '11x11', alt: '+') %>
background: brown image-url('bg_footer.gif') repeat-x 0 0; put the image in the assets/img folder
background: brown url('/assets/bg_footer.gif') repeat-x 0 0; regular css
```

### forms

- form helper types

```
<%= text_field_tag('name', params[:name]) %>
<%= text_field(:subject, :name) %>
<%= f.text_field(:name) %>
text_field radio_button
password_field check_box
text_area file_field
hidden_field label
```

- a sample form with all

```
<h1>My full form</h1>

<div class="Demo form">
	<%= form_for(@subject, html: {multipart: true}) do |f| %>
		<%= f.label(:name) %>
		<%= f.text_field(:name, :size => 40, :maxlength => 40) %>
		<%= f.password_field(:password, :size => 40) %>
		<%= f.hidden_field(:token, 'abcdef0123456789') %>
		<%= f.text_area(:description, :size => "40x5") %>

		<%= f.radio_button(:content_type, 'text') %> Text
		<%= f.radio_button(:content_type, 'HTML') %> HTML
		<%= f.check_box(:visible) %>
		<%= f.file_field(:logo) %> # requires :multipart => true
	<% end %>
</div>
```

- ** form option helper, select dropdown list item**

```
select(object, attribute, choices, options, html_options)
Options:
:selected => object.attribute
:include_blank => false
:prompt => false
:disabled => false
```

- different ways to use it

```
form_for(@section) do |f|
	# Range
	f.select( :position, 1..5 )

	# Array
	f.select( :content_type, ['text', 'HTML'] )

	# Hash
	f.select( :visible, { "Visible" => 1, "Hidden" => 2} )

	# Array of arrays
	f.select( :page_id, Page.all.map {|p| [ p.name, p.id ]} )
end
```

### date and time form helpers

- using the date_select and time_select

```
date_select(object, attribute, options, html_options)
Options: 
:start_year => Time.now.year-5
:end_year => Time.now.year+5
:order => [:year, :month, :day]
:discard_year => false
:discard_month => false
:discard_day => false
:prompt => false
:use_month_numbers => false
:add_month_numbers => false
:use_short_month => false
:date_separator => ""
```

- time_select

```
time_select(object, attribute, options, html_options)
Options: 
:include_seconds => false
:minute_step => 1
:include_blank =>
:prompt =>
:time_separator => ":"
```

- datetime_select

```
datetime_select(object, attribute, options, html_options)
Options:
#all date_select and time_select optins
:datetime_separator => "-"
```

- **using the datetime selctor**

```
<td><%= f.datetime_select(:created_at, order: [:month, :day, :year], start_year: Time.now.year-15, :use_short_month => true) %></td>
```

### form errors

- create shared/error_messages partial

```
<% if object && object.errors.size > 0 %>
	<div id="error-explanation">
		<h2><%= pluralize(object.errors.size, "error") %> prohibited this record from being saved</h2>
		<p>There were problems with the following fields:</p>
		<ul>
			<% object.errors.full_messages.each do |msg| %>
				<li><%= msg %></li>
			<% end %>
		</ul>
	</div>
<% end %>
```

- create a helper for the error partial
- in the application_helper add the method

```
  def error_messages_for(object)
  	render(partial: 'shared/error_messages', locals: {object: object})
  end
```

- then in the form partial, like subject/form partial

```
<%= error_messages_for(f.object) %>
```

- when the error appears, it adds a class to the error field, we can css it

```
.field_with_errors {
	label { color: #aa0000; }
	input { border: 1px solid red; }
}

```

### validations

- 10 validation methods are:

```
validates_presence_of validates_format_of
validates_length_of validates_uniqueness_of
validates_numericality_of validates_acceptance_of
validates_inclusion_of validates_confirmation_of
validates_exclusion_of validates_associated
```

- in admin_user.rb

```
class AdminUser < ApplicationRecord
  # self.table_name = 'admin_users'
  has_and_belongs_to_many :pages
  has_many :section_edits
  has_many :sections, :through => :section_edits

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

  validates_presence_of :first_name
  validates_length_of :first_name, :maximum => 25
  validates_presence_of :last_name
  validates_length_of :last_name, :maximum => 50
  validates_presence_of :username
  validates_length_of :username, :within => 8..25
  validates_uniqueness_of :username
  validates_presence_of :email
  validates_length_of :email, :maximum => 100
  validates_format_of :email, :with => EMAIL_REGEX
  validates_confirmation_of :email
end
```

- writing it 'sexy validation'

```
validates :email, :presence => true,
									:length => { :maximum => 50 }
									:uniqueness => true,
									:format => { :with => EMAIL_REGEX }
									:confirmation => true
```

- full validation list

```
validates :attribute, :presence => boolean,
											:numericality => boolean,
											:length => options_hash,
											:format => {:with => regex},
											:inclusion => {:in => array_or_range},
											:exclusion => {:in => array_or_rante},
											:acceptance => boolean,
											:uniqueness => boolean, 
											:confirmation => boolean
```

- custom validations example

```
validate :custom_method
private
def custom_method
	if test_case
		errors.add(:attribute, 'message')
	end
end

  FORBIDDEN_USERNAMES = ['littlebopeep', 'humptydumpty', 'marymary']
  validates :username_is_allowed

  private
  def username_is_allowed
    if FORBIDDEN_USERNAMES.include?(username)
      errors.add(:username, 'has been restricted from use.')
    end
  end     
```

### Cookies and sessions

- gave explanations on how to use

### controller filters

- the 3 filters are

```
before_action
after_action
around_action
```

- filters in application controller are inherited by all controllers
- inherited filters can be skipped with

```
skip_before_action
skip_after_aciton
skip_around_action
```

### logging

-  rails log:clear to clear log/development.log
- in conf/env/prod the log is

```
  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug
```

- he suggests

```
  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :warn
```  

- to print a message to the log, go to subjects controller

```
  def index
    logger.debug('*** testing the logger ***')
    @subjects = Subject.sorted
  end
```

- refresh the page and see the log, it should appear

### authentication

- in gemfile, uncomment: 

```
gem 'bcrypt', '~> 3.1.7'  
```

- bundle
- rails g migration AddPasswordDigestToAdminUsers
- update the migration file

```
class AddPasswordDigestToAdminUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column "admin_users", "hashed_password"
    add_column "admin_users", "password_digest", :string
  end

  def down
    remove_column "admin_users", "password_digest"   
    remove_column "admin_users", "hashed_password", :string , :limit => 40
  end
end
```

- rails db:migrate
- in admin_user.rb add up top

```
has_secure_password
```

- in rails c

```
u = AdminUser.first
u.password = 'asdfasdf'
u.password_digest, should show the digest created
u.authenticate('asdfasdf'), and it should return the user to us
```

- rails g controller Access menu login
- update the routes to be:

```
	get 'admin', :to => 'access#menu'
  get 'access/menu'
  get 'access/login'
  post 'access/attempt_login'
  get 'access/logout'
```

- update the access/menu file with

```
<% @page_title = "Admin Menu" %>

<div class="menu">
	<h2>Admin Menu</h2>
	<div class="identity">Logged in as:</div>
	<ul>
		<li><%= link_to("Manage Subjects", subjects_path) %></li>
		<li><%= link_to("Manage Pages", pages_path) %></li>
		<li><%= link_to("Manage Sections", sections_path) %></li>
		<li><%= link_to("Manage Admin Users", "#") %></li>
		<li><%= link_to("Logout", access_logout_path) %></li>
	</ul>
</div>
```

- update access/login page

```
<% @page_title = "Admin Login" %>
<div class="login">
	<%= form_tag(access_attempt_login_path, :method => :post) do %>
		<table>
			<tr>
				<td><%= label_tag(:username) %></td>
				<td><%= text_field_tag(:username, params[:username]) %></td>
			</tr>
			<tr>
				<td><%= label_tag(:password) %></td>
				<td><%= password_field_tag(:password) %></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><%= submit_tag("Log In") %></td>
			</tr>
		</table>
	<% end %>
</div>
```

- update access_controller

```
class AccessController < ApplicationController
  layout 'admin'
  def menu
  end

  def login
  end

  def attempt_login
    if params[:username].present? && params[:password].present?
      found_user = AdminUser.where(:username => params[:username]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end

    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "You are now logged in."
      redirect_to(admin_path)
    else
      # flash.now displays the message in the current page, instead of in the following page
      flash.now[:notice] = 'Invalid username/password combination.'
      render('login')
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logged Out'
    redirect_to(access_login_path)
  end
end

```

- to restrict acces, in the applcation controller add the private method

```
  private

  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(access_login_path)
    end
  end
```

- in all controller add

```
before_action :confirm_logged_in
```

- in the access controller add

```
before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]
```

### AdminUser CRUD

- in admin_user.rb

```
  scope :sorted, lambda { order('last_name ASC, first_name ASC') }
  
  def name
    "#{first_name} #{last_name}"
    #  or: first_name + ' ' + last_name
    #  or: [first_name, last_name].join(' ')
    #  or: self.first_name + ' ' + self.last_name

  end
```

- rails g controller AdminUsers index new edit delete
- update routes

```
  resources :admin_users, :except => [:show] do
    member do
      get :delete
    end
  end
```

### public area

- rails g controller Public index show
- update routes

```
  root 'public#index'

  get 'show/:permalink', :to => 'public#show'

```

- update public controller

```
class PublicController < ApplicationController
  layout 'public'

  def index
  end

  def show
    @page = Page.visible.where(:permalink => params[:permalink]).first
    if @page.nil?
      redirect_to(root_path)
    else
      # display the page content using show.html.erb
    end
  end
end
```

### nesting pages

- see code

### using the acts as list gem

- install acts as list gem
- bundle
- restart server
- in the models: subject

```
acts_as_list
```
- in section and page model add, respectively:

```
acts_as_list :scope => :page
acts_as_list :scope => :subject
```

- 

### list of top gems

- heres a list of gems he uses in almost all projects

```
acts_as_list
will_paginate
exception_notification
paperclip
carrierwave
delayed_job
friendly_id
activemerchant
```

## The End