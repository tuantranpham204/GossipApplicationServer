source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.1"

# The database adapter
gem 'pg', '~> 1.1'

# --- AUTHENTICATION (Use cases 1, 2, 3) ---
gem 'devise'        # Core authentication
gem 'devise-jwt'    # JWT extension for Devise (Essential for APIs)
gem 'omniauth'      # Base framework for social login
gem 'omniauth-google-oauth2' # Login with Google
# Note: You usually need specific strategies too, e.g., gem 'omniauth-google-oauth2'

# --- PERMISSIONS (All use cases) ---
gem 'pundit'        # Object-oriented authorization

# --- SEARCH (Use cases 4, 9) ---
gem 'ransack'       # Search logic generator

# --- MESSAGING / REAL-TIME (Use cases 7, 8, 10, 11, 14-17) ---
# ActionCable is BUILT-IN to 'rails'. You do not need a separate gem.
# However, you DO need Redis for ActionCable to work in production/staging.
gem 'redis'

# --- BACKGROUND JOBS (Use cases 1, 7, 8, 12, 13, 16, 18, a.2) ---
gem 'sidekiq'       # Background processing

# --- MEDIA (Use cases 5, 8) ---
gem 'cloudinary'    # Image/Video upload and management

# --- PAGINATION (Use cases 4, 18, 19, a.1) ---
gem 'kaminari'      # Pagination for Active Record

# --- DATABASE OPTIMIZATION (Use cases 7, 8, 12, 13) ---
gem 'polymorphic_integer_type' # Maps integer column to model class names

# --- API DOCUMENTATION (Swagger/OpenAPI) ---
gem 'rspec-rails'
gem 'rswag-api'
gem 'rswag-ui'
gem 'rswag-specs'

# -- DEBUG
gem 'pry'
# Optional: Add pry-byebug for step-through debugging commands
gem 'pry-byebug'

# Language
gem 'rails-i18n'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # Load environment variables from .env file
  gem "dotenv-rails"
end
