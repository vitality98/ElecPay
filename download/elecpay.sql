#Account
create table account
(
    id       int auto_increment
        primary key,
    name     varchar(32) default 'Anonymity'          not null,
    balance  double      default 0                    not null,
    username varchar(32)                              not null,
    password varchar(32)                              not null,
    email    varchar(50) default 'NoneEmail@none.com' not null,
    gender   varchar(32)                              null,
    birthday date                                     null,
    status   int         default 0                    not null,
    constraint account_username_uindex
        unique (username)
);

INSERT INTO elecpay.account (id, name, balance, username, password, email, gender, birthday, status) VALUES (1, 'Lixuran', 500, 'lixuran', '123456', 'lixuran@qq.com', 'male', '2020-02-13', 0);
INSERT INTO elecpay.account (id, name, balance, username, password, email, gender, birthday, status) VALUES (9, 'TestRobot', 500, 'test', '123456', 'test@qq.com', 'male', '2016-02-05', 0);
INSERT INTO elecpay.account (id, name, balance, username, password, email, gender, birthday, status) VALUES (10, 'Tangyuan', 500, 'tangyuan', '123456', 'tangyuan@qq.com', 'female', '2009-02-20', 0);
INSERT INTO elecpay.account (id, name, balance, username, password, email, gender, birthday, status) VALUES (12, 'Jack', 0, 'jack', '123456', 'jack@gmail.com', 'male', '2021-02-12', 0);
INSERT INTO elecpay.account (id, name, balance, username, password, email, gender, birthday, status) VALUES (23, 'Shawn', 0, 'shawn', '123456', 'Shawn@qq.com', 'female', '1997-02-20', 0);
INSERT INTO elecpay.account (id, name, balance, username, password, email, gender, birthday, status) VALUES (25, 'Jackson', 500, 'jackson', '123456', 'jackson@gmail.com', 'male', '1990-08-04', 0);

#Park
create table park
(
    id       int auto_increment
        primary key,
    name     varchar(32)      null,
    location varchar(32)      null,
    status   int    default 0 not null,
    balance  double default 0 not null,
    username varchar(32)      not null,
    password varchar(32)      not null,
    price    double default 0 not null,
    capacity int    default 0 not null,
    constraint park_username_uindex
        unique (username)
);

INSERT INTO elecpay.park (id, name, location, status, balance, username, password, price, capacity) VALUES (1, 'SwiftPark', '227 G/F, Pofulam road, Hong Kong', 0, 0, 'park1', 'park1', 20, 100);
INSERT INTO elecpay.park (id, name, location, status, balance, username, password, price, capacity) VALUES (2, 'none', 'none', 0, 0, 'none', 'none', 0, 100);
INSERT INTO elecpay.park (id, name, location, status, balance, username, password, price, capacity) VALUES (3, 'HappyPark', '98 UG/F, Queen road, Hong Kong ', 0, 0, 'park2', 'park2', 18, 100);
INSERT INTO elecpay.park (id, name, location, status, balance, username, password, price, capacity) VALUES (4, 'BigPark', '34 B1/F, Big Street, Hong Kong', 0, 0, 'park3', 'park3', 30, 200);
INSERT INTO elecpay.park (id, name, location, status, balance, username, password, price, capacity) VALUES (5, 'LittlePark', '21 G/F, Little road, Hong Kong', 0, 0, 'park4', 'park4', 2, 20);

#Car
create table car
(
    id      int auto_increment
        primary key,
    name    varchar(32)   null,
    status  int default 0 not null,
    park    int default 2 not null,
    licence varchar(32)   not null,
    constraint car_licence_uindex
        unique (licence),
    constraint car_park_id_fk
        foreign key (park) references park (id)
);

#Card
create table card
(
    id      int auto_increment
        primary key,
    number  varchar(100)     not null,
    balance double default 0 not null,
    bank    varchar(32)      not null,
    constraint card_number_uindex
        unique (number)
);

INSERT INTO elecpay.card (id, number, balance, bank) VALUES (1, '1234567890', 1000000, 'Hong Kong Bank');
INSERT INTO elecpay.card (id, number, balance, bank) VALUES (2, '8888888888', 10000, 'The Swift Bank');
INSERT INTO elecpay.card (id, number, balance, bank) VALUES (3, '9999999999', 500, 'Hello World Bank');
INSERT INTO elecpay.card (id, number, balance, bank) VALUES (4, '0000000000', 2000, 'Base');

#account_car
create table account_car
(
    id      int auto_increment
        primary key,
    account int not null,
    car     int not null,
    constraint account_car_car_id_fk
        unique (car),
    constraint account_car_account_id_fk
        foreign key (account) references account (id)
            on update cascade on delete cascade,
    constraint account_car_car_id_fk
        foreign key (car) references car (id)
            on update cascade on delete cascade
);

#account_card
create table account_card
(
    id      int auto_increment
        primary key,
    account int not null,
    card    int not null,
    constraint account_card_account_id_fk
        foreign key (account) references account (id)
            on update cascade on delete cascade,
    constraint account_card_card_id_fk
        foreign key (card) references card (id)
            on update cascade on delete cascade
);

INSERT INTO elecpay.account_card (id, account, card) VALUES (4, 1, 1);
INSERT INTO elecpay.account_card (id, account, card) VALUES (7, 1, 2);
INSERT INTO elecpay.account_card (id, account, card) VALUES (12, 1, 3);

#account_record
create table bill_record
(
    trade_no  varchar(100) not null,
    id        int auto_increment
        primary key,
    timestamp varchar(100) not null,
    amount    double       not null,
    payer_id  int          not null,
    park_id   int          not null,
    constraint bill_record_trade_no_uindex
        unique (trade_no),
    constraint bill_record_account_id_fk
        foreign key (payer_id) references account (id),
    constraint bill_record_park_id_fk
        foreign key (park_id) references park (id)
);

#parking
create table parking
(
    id        int auto_increment
        primary key,
    username  varchar(64) not null,
    car       varchar(64) not null,
    timestamp datetime    not null,
    constraint parking_car_uindex
        unique (car),
    constraint parking_account_username_fk
        foreign key (username) references account (username),
    constraint parking_car_licence_fk
        foreign key (car) references car (licence)
);

#refund_record
create table refund_record
(
    id        int auto_increment
        primary key,
    timestamp varchar(100) not null,
    amount    double       not null,
    username  varchar(64)  not null,
    role      varchar(32)  not null
);

#topup_record
create table topup_record
(
    trade_no     varchar(100)                               not null,
    timestamp    varchar(100) default '2000-01-01 00:00:00' not null,
    total_amount double                                     not null,
    username     varchar(64)                                not null,
    id           int auto_increment
        primary key,
    constraint topup_record_trade_no_uindex
        unique (trade_no),
    constraint topup_record_account_username_fk
        foreign key (username) references account (username)
);

#transfer_record
create table transfer_record
(
    id          int auto_increment
        primary key,
    sender_id   int              not null,
    receiver_id int              not null,
    amount      double default 0 not null,
    timestamp   varchar(100)     not null,
    note        varchar(80)      null,
    constraint pay_record_account_id_fk
        foreign key (sender_id) references account (id),
    constraint pay_record_park_id_fk
        foreign key (receiver_id) references account (id)
);

#user_key
create table user_key
(
    id       int auto_increment
        primary key,
    username varchar(64) not null,
    keyy     varchar(32) not null,
    constraint user_key_username_uindex
        unique (username),
    constraint user_key_account_username_fk
        foreign key (username) references account (username)
            on update cascade on delete cascade
);

INSERT INTO elecpay.user_key (id, username, keyy) VALUES (1, 'lixuran', '333333');