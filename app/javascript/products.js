document.addEventListener('turbo:load', function() {
  var buttons = document.querySelectorAll('.add-product-button');
  buttons.forEach(function(button) {
    button.removeEventListener('click', handleClick);
    button.addEventListener('click', handleClick);
  });
});

var totalProtein = 0;
var totalFat = 0;
var totalCarbohydrates = 0;

function handleClick(event) {
event.preventDefault();
var button = event.currentTarget;
var productId = button.dataset.productId;
var productName = button.dataset.productName;
var productProtein = parseFloat(button.dataset.productProtein);
var productFat = parseFloat(button.dataset.productFat);
var productCarbohydrates = parseFloat(button.dataset.productCarbohydrates);

// Добавляем продукт в список
var li = document.createElement('li');
li.classList.add('product-item');  // Добавляем класс к элементу списка

var span = document.createElement('span');
span.textContent = productName + ": белки " + productProtein + ", жири " + productFat + ", углеводы " + productCarbohydrates;
span.classList.add('product-info');  // Добавляем класс к информации о продукте

var input = document.createElement('input');
input.type = 'number';
input.value = 100.0;
input.classList.add('product-quantity');  // Добавляем класс к полю ввода

li.appendChild(span);
li.appendChild(input);

var selectedProductsList = document.getElementById('selected_products_list');
selectedProductsList.appendChild(li);

// Обновляем суммарные значения БЖУ
updateTotals();

// Добавляем обработчик события для изменения значения в поле ввода
input.addEventListener('input', updateTotals);

console.log('Продукт добавлен: ' + productName);
}

function updateTotals() {
totalProtein = 0;
totalFat = 0;
totalCarbohydrates = 0;

var products = document.querySelectorAll('#selected_products_list li');
products.forEach(function(product) {
  var productProtein = parseFloat(product.textContent.match(/белки (\d+\.?\d*)/)[1]);
  var productFat = parseFloat(product.textContent.match(/жири (\d+\.?\d*)/)[1]);
  var productCarbohydrates = parseFloat(product.textContent.match(/углеводы (\d+\.?\d*)/)[1]);
  var quantity = parseFloat(product.querySelector('input').value);
  
  totalProtein += productProtein / 100.0 * quantity;
  totalFat += productFat / 100.0 * quantity;
  totalCarbohydrates += productCarbohydrates / 100.0 * quantity;
});

updateTotalValues();
checkLimits();
}

function updateTotalValues() {
document.getElementById('total_protein').textContent = 'Общие белки: ' + totalProtein.toFixed(2);
document.getElementById('total_fat').textContent = 'Общие жири: ' + totalFat.toFixed(2);
document.getElementById('total_carbohydrates').textContent = 'Общие углеводы: ' + totalCarbohydrates.toFixed(2);
}

function checkLimits() {
var totalFatElement = document.getElementById('total_fat');
var totalProteinElement = document.getElementById('total_protein');
var totalCarbohydratesElement = document.getElementById('total_carbohydrates');

// Сброс классов
totalFatElement.classList.remove('red');
totalProteinElement.classList.remove('red');
totalCarbohydratesElement.classList.remove('red');

// Проверка и добавление классов
if (totalFat > dailyFats) {
  totalFatElement.classList.add('red');
}
if (totalProtein > dailyProteins) {
  totalProteinElement.classList.add('red');
}
if (totalCarbohydrates > dailyCarbohydrates) {
  totalCarbohydratesElement.classList.add('red');
}
}

