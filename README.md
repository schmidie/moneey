 
## moneey - just another money gem

### Configure the convertion rates to a base
For money convertion you need to configure the convertion rates.
Note that you also need this for arithmetic and comparison with different currencies.
```
Money.conversion_rates('EUR', {
  'USD'     => 1.11,
  'Bitcoin' => 0.0047
})
```

### Instantiate a new moneey object
```
twenty_eur = Money.new(20, 'EUR')
ten_usd = Money.new(10, 'USD')
```
### Arithmetic operations
```
twenty_eur + twenty_eur
twenty_eur - ten_usd
twenty_eur * 5
ten_usd / 2
```

### Comparisons
```
twenty_eur < ten_usd      => false
twenty_eur > ten_usd      => true
twenty_eur <= twenty_eur  => true
twenty_eur == twenty_eur  => true
```

### Convertion
```
twenty_eur.convert_to('USD')
```

### Inspect the object
```
twenty_eur.amount   => 20
fifty_eur.currency  => "EUR"
fifty_eur.inspect   => "20.00 EUR"
```
