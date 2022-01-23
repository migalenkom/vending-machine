# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
User.create([{ username: 'roma', password: 'roma', role: 'seller' },
             { username: 'mike', password: 'mike', role: 'buyer' }])

Product.create([{ name: 'Pencil', cost: 5, amount: 100, seller: User.first },
                { name: 'Pen', cost: 10, amount: 100, seller: User.first }])
