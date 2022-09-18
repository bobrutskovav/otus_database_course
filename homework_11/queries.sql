use sensors;


delimiter //
create procedure rename_zone_and_title_devices(IN zone_id_to_change INT, IN new_title VARCHAR(255))
begin
    start transaction;
    update zone set title = new_title where id = zone_id_to_change;
    update device d
        inner join sensors.zone as z on d.zone_id = z.id
    set d.title = concat(d.title,' in zone ', z.title)
    where z.id = zone_id_to_change;
    commit;
end//




call rename_zone_and_title_devices(1,'New My Room Title')



####################################

SHOW VARIABLES LIKE 'secure_file_priv';
SELECT @@global.secure_file_priv;


SET GLOBAL local_infile = true;

create table test_load(Handle VARCHAR(255),
Title VARCHAR(255),
Body_HTML VARCHAR(255),
Vendor VARCHAR(255),
Type VARCHAR(255),
Tags VARCHAR(255),
Published VARCHAR(255),
Option1_Name VARCHAR(255),
Option1_Value VARCHAR(255),
Option2_Name VARCHAR(255),
Option2_Value VARCHAR(255),
Option3_Name VARCHAR(255),
Option3_Value VARCHAR(255),
Variant_SKU VARCHAR(255),
Variant_Grams VARCHAR(255),
Variant_Inventory_Tracker VARCHAR(255),
Variant_Inventory_Qty VARCHAR(255), Variant_Inventory_Policy VARCHAR(255),
Variant_Fulfillment_Service VARCHAR(255),
Variant_Price VARCHAR(255),
Variant_Compare_At_Price VARCHAR(255),
Variant_Requires_Shipping VARCHAR(255),
Variant_Taxable VARCHAR(255),
Variant_Barcode VARCHAR(255),
Image_Src VARCHAR(255),
Image_Alt_Text VARCHAR(255),
Gift_Card VARCHAR(255),
SEO_Title VARCHAR(255),
SEO_Description VARCHAR(255),
Google_Shopping_Google_Product_Category VARCHAR(255),
Google_Shopping_Gender VARCHAR(255),
Google_Shopping_Age_Group VARCHAR(255),
Google_Shopping_MPVARCHAR VARCHAR(255),
Google_Shopping_AdWords_Grouping VARCHAR(255),
Google_Shopping_AdWords_Labels VARCHAR(255),
Google_Shopping_Condition VARCHAR(255),
Google_Shopping_Custom_Product VARCHAR(255),
Google_Shopping_Custom_Label_0 VARCHAR(255),
Google_Shopping_Custom_Label_1 VARCHAR(255),
Google_Shopping_Custom_Label_2 VARCHAR(255),
Google_Shopping_Custom_Label_3 VARCHAR(255),
Google_Shopping_Custom_Label_4 VARCHAR(255),
Variant_Image VARCHAR(255),
Variant_Weight_Unitcreated_at VARCHAR(255));

LOAD DATA LOCAL INFILE 'C:\\Users\\Aleks\\DataGripProjects\\otus_database_course\\homework_11\\SnowDevil.csv'
    INTO TABLE test_load
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\n';