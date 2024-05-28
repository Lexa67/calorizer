// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


import { initializeSearch } from './search.js';

document.addEventListener('turbo:load', () => {
  initializeSearch();
});
