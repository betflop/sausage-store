CREATE ROLE read_user;
CREATE ROLE write_user;
CREATE ROLE admin_user;

GRANT SELECT ON product, orders, order_product TO read_user;
GRANT USAGE ON product, orders, order_product TO read_user;

GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON product, orders, order_product TO write_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN product, orders, order_product TO write_user;

GRANT ALL ON product, orders, order_product TO admin_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO admin_user;
