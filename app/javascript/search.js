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
        });
      });
    }
  }
  