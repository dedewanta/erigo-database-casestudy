# Pilih database
use erigo;

# Cek apakah table berhasil diimport atau tidak
select * from customer;
select * from ordering;
select * from product;
select * from sales;
select * from shipping;
select * from status;

# Jumlah product tiap-tiap kategori
select category, count(category)
from product group by category
order by category;

# Lima product termahal
select name, price from product
order by price desc
limit 0, 5;

# Product jaket termahal
select name, price from product
where category='jacket'
order by price desc;

# Product dengan keuntungan tiap product terkecil
select name, (price-prod_cost) as keuntungan
from product
order by keuntungan asc;

# Tiga customer dengan pembelian terbanyak
select cust_id, name, count(cust_id) as jumlah_pembelian
from ordering
inner join customer using(cust_id)
group by cust_id
order by jumlah_pembelian desc
limit 0,3;

# Customer yang memiliki akun namun tidak melakukan pembelian pada 4-8 Oktober 2022
select cust_id, name
from ordering
right join customer using(cust_id)
where order_id is null;

# Jumlah customer tiap-tiap provinsi
select ship_prov, count(ship_prov) as jumlah_user
from customer
group by ship_prov
order by ship_prov asc;

# Jumlah customer yang memiliki akun namun tidak melakukan pembelian pada 4-8 Oktober 2022 tiap daerah
select ship_prov, count(ship_prov) as jumlah_user_inact
from ordering
right join customer using(cust_id)
where order_id is null
group by ship_prov
order by ship_prov asc;

# Lima customer dengan pembelian terbanyak pada tanggal 7 Oktober 2022
select cust_id, name, count(cust_id) as jumlah_pembelian
from ordering
inner join customer using(cust_id)
where order_date = '2022-10-07'
group by cust_id
order by jumlah_pembelian desc
limit 0,6;

# Product dengan keuntungan tertinggi
select product.product_id, product.name,
count(product.product_id) as product_sold, sum(product.price-product.prod_cost) as keuntungan
from ordering
inner join sales using(order_id)
inner join product using(product_id)
group by product.product_id
order by keuntungan desc;

# Total keuntungan per hari
select ordering.order_date,
count(product.product_id) as sales, sum(product.price-product.prod_cost) as keuntungan
from ordering
inner join sales using(order_id)
inner join product using(product_id)
group by ordering.order_date
order by order_date asc;

# Traffic penjualan
select order_source, count(order_source) as sold
from ordering
group by order_source
order by sold desc;

# Traffic penjualan pada 4 Oktober 2022
select order_source, count(order_source) as sold_20221004
from ordering
where order_date='2022-10-04'
group by order_source
order by sold_20221004 desc;

# Mengetahui status pengiriman pesanan saat ini
select shipping.status, count(shipping.status) as jumlah
from shipping
inner join ordering on shipping.ship_id = ordering.shipping_id
group by shipping.status
order by ship_id asc;

# Mengetahui status pesanan saat ini
select status.status, count(shipping.status_order) as jumlah
from shipping
inner join ordering on shipping.ship_id = ordering.shipping_id
inner join status on shipping.status_order = status.status_order
group by shipping.status_order
order by ship_id asc;

# Sebaran penjualan size
select size, count(size) as sold
from sales
group by size
order by sold desc;

# Sebaran usia pengguna (termasuk inact) pada database
select
	case
		when usia < 18 then 'Di bawah 18'
        when usia between 18 and 20 then '18-20 tahun'
        when usia between 21 and 30 then '21-30 tahun'
        when usia between 31 and 40 then '31-40 tahun'
        when usia between 41 and 50 then '41-50 tahun'
        when usia between 51 and 60 then '51-60 tahun'
        when usia > 60 then 'Di atas 60'
	end as range_usia,
count(cust_id) as jumlah_user
from customer
group by range_usia order by range_usia;

# Sebaran usia pengguna yang aktif bertransaksi pada 4-8 Oktober 2022
select
	case
		when usia < 18 then 'Di bawah 18'
        when usia between 18 and 20 then '18-20 tahun'
        when usia between 21 and 30 then '21-30 tahun'
        when usia between 31 and 40 then '31-40 tahun'
        when usia between 41 and 50 then '41-50 tahun'
        when usia between 51 and 60 then '51-60 tahun'
        when usia > 60 then 'Di atas 60'
	end as range_usia,
count(distinct(ordering.cust_id)) as jumlah_user
from customer
inner join ordering using(cust_id)
group by range_usia order by range_usia;

# Sebaran status member user pada database (termasuk inact)
select status, count(status) as jumlah_user
from customer
group by status;

# Sebaran status member user yang aktif transaksi pada 4-8 Oktober 2022
select status, count(distinct(ordering.cust_id)) as jumlah_user
from customer
inner join ordering using(cust_id)
group by status order by status desc;

# Sebaran jenis kelamin user pada database (termasuk inact)
select
	case
		when gender='m' then 'Laki-laki'
        when gender='f' then 'Perempuan'
	end as jenis_kelamin,
count(gender) as jumlah_user
from customer
group by gender order by gender desc;

# Sebaran jenis kelamin user aktif tanggal 4-8 Oktober 2022 pada database
select
	case
		when gender='m' then 'Laki-laki'
        when gender='f' then 'Perempuan'
	end as 'Jenis Kelamin',
count(distinct(ordering.cust_id)) as 'Jumlah User'
from customer
inner join ordering using(cust_id)
group by gender order by gender desc;

# Sebaran jenis kelamin user aktif tanggal 4-8 Oktober 2022 yang membeli antelope black
select
	case
		when gender='m' then 'Laki-laki'
        when gender='f' then 'Perempuan'
	end as 'Jenis Kelamin',
count(distinct(ordering.cust_id)) as 'jumlah user pembeli antelope black'
from customer
inner join ordering using(cust_id)
inner join sales using(order_id)
inner join product using(product_id)
where product.name = 'antelope black'
group by gender order by gender desc;