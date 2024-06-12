export function initializeSearch() {  
  const searchInput = document.getElementById('search-input');

  if (searchInput) {
    searchInput.addEventListener('input', () => {
      const form = document.getElementById('search-form');
      const url = form.action;
      const query = searchInput.value;

      fetch(`${url}?search=${query}`, {
        headers: { 'Accept': 'text/javascript' }
      })
      .then(response => response.text())
      .then((data) => {
        // Обновление списка продуктов на основе данных из контроллера
        const productsList = document.getElementById('products-list');
        productsList.innerHTML = data;

        // Повторная инициализация обработчиков событий
        initializeProductButtons();
      });
    });
  }
}

function initializeProductButtons() {
  const buttons = document.querySelectorAll('.add-product-button');
  buttons.forEach((button) => {
    button.removeEventListener('click', handleClick);
    button.addEventListener('click', handleClick);
  });
}

// Инициализация обработчиков событий при загрузке страницы
document.addEventListener('turbo:load', () => {
  initializeSearch();
  initializeProductButtons();
});
