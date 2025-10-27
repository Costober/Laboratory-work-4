// ProgramCodeModified.js - Навмисні порушення
var product_name = 'Integrated Stability Tracker' // Порушення: var, одинарні лапки, відсутність ;

function DisplayProductName() // Порушення: назва функції не camelCase
{
  console.log('Продукт: ' + product_name) // Порушення: одинарні лапки, немає шаблонів рядків
}

DisplayProductName() // Порушення: відсутність ;
