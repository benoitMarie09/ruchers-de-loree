document.getElementById('scroll-to-products').addEventListener('click', () => {
  // On récupère la section produits (il faut que tu aies un id="products" sur ta section)
  const productsSection = document.getElementById('products');
  if (productsSection) {
    productsSection.scrollIntoView({ behavior: 'smooth' });
  }
});
