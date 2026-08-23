-- Создаем схему 
CREATE SCHEMA IF NOT EXISTS my_schema;

-- Создаем таблицу пользователей в этой схеме
CREATE TABLE my_schema.users (
    id INTEGER PRIMARY KEY,
    login VARCHAR(256) UNIQUE NOT NULL,
    password VARCHAR(256) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    last_login_at TIMESTAMPTZ NOT NULL
);

--Создание таблицы ролей
CREATE TABLE my_schema.role (
    id INTEGER PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true
);

--Создание таблицы уведомлений 
CREATE TYPE  my_schema.addressee_type AS enum ('student', 'teacher', 'admin', 'moderator', 'all', 'course_members');

CREATE TABLE my_schema.notification (
  id INTEGER PRIMARY KEY,
  code VARCHAR(60) UNIQUE NOT NULL,
  topic VARCHAR(60) NOT NULL,
  body_mask TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  addressee addressee_type NOT NULL
);

--Создание таблицы статусов
CREATE TABLE my_schema.status (
id INTEGER PRIMARY KEY,
name VARCHAR(32) NOT NULL,
description TEXT NOT NULL,
update_at TIMESTAMPTZ NOT null,
state VARCHAR(32) NOT NULL,
entity_type VARCHAR(32) NOT null
);

--Создание таблицы категорий 
CREATE TABLE my_schema.category (
id INTEGER PRIMARY KEY,
name VARCHAR(32) NOT NULL
);

--Создание таблицы студентов 
CREATE TABLE my_schema.student (
id INTEGER PRIMARY KEY,
user_id INTEGER NOT null REFERENCES my_schema.users(id) ON DELETE CASCADE,
surname VARCHAR(32) NOT NULL,
first_name VARCHAR(32) NOT NULL,
middle_name VARCHAR(32),
email VARCHAR(256) UNIQUE NOT NULL,
phone VARCHAR(16) UNIQUE NOT NULL,
birthday DATE,
city VARCHAR(32),
gender CHAR(1) CHECK (gender IN ('м', 'ж', 'M', 'F')),
is_active BOOLEAN NOT NULL DEFAULT true
);

--Создание таблицы пресонала 
CREATE TABLE my_schema.staff (
id INTEGER PRIMARY KEY,
user_id INTEGER NOT null REFERENCES my_schema.users(id) ON DELETE CASCADE,
surname VARCHAR(32) NOT NULL,
first_name VARCHAR(32) NOT NULL,
middle_name VARCHAR(32),
phone VARCHAR(16) UNIQUE NOT NULL,
position  VARCHAR(256) NOT null, 
hired_at DATE not null, 
dismissal_at DATE, 
is_active BOOLEAN NOT NULL DEFAULT true
);

--Создание таблицы журнала действий 
CREATE TABLE my_schema.action_log (
id INTEGER PRIMARY KEY,
user_id INTEGER NOT null REFERENCES my_schema.users(id) ON DELETE CASCADE,
created_at TIMESTAMPTZ NOT NULL,
action VARCHAR(1024) NOT null
 );

--Создание таблицы роли персонала 
CREATE TABLE my_schema.role_staff (
id INTEGER PRIMARY KEY,
staff_id INTEGER NOT null REFERENCES my_schema.staff(id) ON DELETE CASCADE,
roleid INTEGER NOT null REFERENCES my_schema.role(id) ON DELETE CASCADE,
created_at TIMESTAMPTZ NOT null
);

--Создание таблицы рассылки уведомлений 

CREATE TYPE  my_schema.entity_type AS enum ('student', 'teacher', 'admin', 'moderator', 'all', 'course_members');

CREATE TABLE my_schema.notification_dispatch (
id INTEGER PRIMARY KEY,
entity_type  my_schema.entity_type NOT NULL,
student_id INTEGER REFERENCES my_schema.student(id) ON DELETE CASCADE,
staff_id INTEGER REFERENCES my_schema.staff(id) ON DELETE CASCADE,
dispatch_at TIMESTAMPTZ NOT null, 
delivered BOOLEAN NOT NULL DEFAULT true,
notifacation_id INTEGER NOT null REFERENCES my_schema.notification(id) ON DELETE cascade
);


--Создание таблицы обращений 
CREATE TABLE my_schema.ticket (
id INTEGER PRIMARY KEY,
users_id INTEGER NOT null REFERENCES my_schema.users(id) ON DELETE cascade, 
staff_id INTEGER NOT null REFERENCES my_schema.staff(id) ON DELETE cascade, 
category_id INTEGER NOT null REFERENCES my_schema.category(id) ON DELETE cascade, 
description TEXT NOT NULL,
created_at TIMESTAMPTZ NOT null,
closed_at TIMESTAMPTZ,
status_id INTEGER NOT null REFERENCES my_schema.status(id) ON DELETE cascade
);


--Создаём таблицу файлов 
CREATE TABLE my_schema.file (
id INTEGER PRIMARY KEY,
name VARCHAR(60) NOT NULL,
type VARCHAR(60) NOT NULL,
created_at TIMESTAMPTZ NOT null, 
size INTEGER NOT null,
--lesson_id INTEGER NOT null REFERENCES lesson(id) ON DELETE cascade, 
--homework_id INTEGER NOT null REFERENCES homework(id) ON DELETE cascade, 
--ticket_id INTEGER NOT null REFERENCES ticket(id) ON DELETE cascade, 
--candidate_request_id INTEGER NOT null REFERENCES candidate_request(id) ON DELETE cascade, 
--student_homework_id INTEGER NOT null REFERENCES student_homework(id) ON DELETE cascade, 
link_FS VARCHAR (128) NOT NULL,
format VARCHAR (60) NOT null,
modification_at TIMESTAMPTZ NOT null,
staff_id INTEGER NOT null REFERENCES my_schema.staff(id) ON DELETE cascade, 
user_id INTEGER NOT null REFERENCES my_schema.users(id) ON DELETE cascade
);


--Создаём таблицу сообщений 
CREATE TABLE my_schema.message (
id INTEGER PRIMARY KEY,
ticket_id INTEGER NOT null REFERENCES my_schema.ticket(id) ON DELETE cascade, 
user_id INTEGER NOT null REFERENCES my_schema.users(id) ON DELETE cascade, 
staff_id INTEGER NOT null REFERENCES my_schema.staff(id) ON DELETE cascade, 
text VARCHAR(1024),
sent_at TIMESTAMPTZ NOT null,
file_id INTEGER REFERENCES my_schema.file(id) ON DELETE cascade
);















-- =====================================================
-- 1. Заполнение таблицы users 
-- =====================================================
INSERT INTO my_schema.users (id, login, password, created_at, is_active, last_login_at) VALUES
(1, 'ivan.petrov', 'hash_password_123', '2024-01-15 10:00:00+03', true, '2026-05-17 09:00:00+03'),
(2, 'maria.sidorova', 'hash_password_456', '2024-02-20 11:30:00+03', true, '2026-05-16 15:30:00+03'),
(3, 'alexey.kozlov', 'hash_password_789', '2024-03-10 09:15:00+03', true, '2026-05-17 10:00:00+03'),
(4, 'elena.volkova', 'hash_password_abc', '2024-01-05 14:00:00+03', false, '2026-04-01 12:00:00+03'),
(5, 'admin.system', 'admin_hash_xyz', '2024-01-01 00:00:00+03', true, '2026-05-17 08:00:00+03'),
(6, 'teacher.ivanov', 'teacher_hash_111', '2024-02-01 10:00:00+03', true, '2026-05-16 16:00:00+03'),
(7, 'moderator.petrov', 'mod_hash_222', '2024-03-01 12:00:00+03', true, '2026-05-15 11:00:00+03'),
(8, 'support.kuzmin', 'support_hash_333', '2024-04-01 14:00:00+03', true, '2026-05-17 07:00:00+03'),
(9, 'student.novikov', 'student_hash_444', '2024-05-01 09:00:00+03', true, '2026-05-16 20:00:00+03');

-- =====================================================
-- 2. Заполнение таблицы role 
-- =====================================================
INSERT INTO my_schema.role (id, name, description, created_at, is_active) VALUES
(1, 'admin', 'Полный доступ ко всем функциям платформы', '2024-01-01 00:00:00+03', true),
(2, 'teacher', 'Доступ к созданию курсов и проверке ДЗ', '2024-01-01 00:00:00+03', true),
(3, 'student', 'Доступ к обучению и просмотру материалов', '2024-01-01 00:00:00+03', true),
(4, 'moderator', 'Модерация контента и пользователей', '2024-01-01 00:00:00+03', true),
(5, 'support', 'Поддержка пользователей', '2024-01-01 00:00:00+03', true),
(6, 'analyst', 'Аналитика и отчеты', '2024-01-01 00:00:00+03', true),
(7, 'content_manager', 'Управление контентом', '2024-01-01 00:00:00+03', true),
(8, 'hr_manager', 'Управление персоналом', '2024-01-01 00:00:00+03', false);

-- =====================================================
-- 3. Заполнение таблицы student 
-- =====================================================
INSERT INTO my_schema.student (id, user_id, surname, first_name, middle_name, email, phone, birthday, city, gender, is_active) VALUES
(1, 1, 'Петров', 'Иван', 'Александрович', 'ivan.petrov@example.com', '+79991234567', '1995-05-15', 'Москва', 'м', true),
(2, 2, 'Сидорова', 'Мария', 'Владимировна', 'maria.sidorova@example.com', '+79997654321', '1998-08-22', 'Санкт-Петербург', 'ж', true),
(3, 3, 'Козлов', 'Алексей', 'Дмитриевич', 'alexey.kozlov@example.com', '+79991112233', '1992-03-10', 'Казань', 'м', true),
(4, 4, 'Волкова', 'Елена', 'Сергеевна', 'elena.volkova@example.com', '+79995554433', '1990-11-01', 'Новосибирск', 'ж', false),
(5, 9, 'Новиков', 'Дмитрий', 'Андреевич', 'dmitry.novikov@example.com', '+79997778899', '2000-07-19', 'Екатеринбург', 'м', true),
(6, 5, 'Морозова', 'Анна', 'Игоревна', 'anna.morozova@example.com', '+79998889900', '1997-02-28', 'Нижний Новгород', 'ж', true),
(7, 6, 'Соколов', 'Павел', 'Николаевич', 'pavel.sokolov@example.com', '+79994445566', '1994-12-03', 'Челябинск', 'м', true),
(8, 7, 'Кузнецова', 'Татьяна', 'Владимировна', 'tatiana.kuznetsova@example.com', '+79993332211', '1996-09-14', 'Самара', 'ж', true);

-- =====================================================
-- 4. Заполнение таблицы staff 
-- =====================================================
INSERT INTO my_schema.staff (id, user_id, surname, first_name, middle_name, phone, position, hired_at, dismissal_at, is_active) VALUES
(1, 5, 'Системов', 'Админ', 'Админович', '+79990001111', 'Системный администратор', '2024-01-01', NULL, true),
(2, 6, 'Иванов', 'Пётр', 'Сергеевич', '+79990002222', 'Преподаватель', '2024-02-01', NULL, true),
(3, 7, 'Петрова', 'Анна', 'Ивановна', '+79990003333', 'Модератор', '2024-03-01', NULL, true),
(4, 8, 'Кузьмин', 'Сергей', 'Петрович', '+79990004444', 'Техподдержка', '2024-04-01', NULL, true),
(5, 1, 'Смирнов', 'Дмитрий', 'Алексеевич', '+79990005555', 'Старший преподаватель', '2023-12-01', '2026-03-01', false),
(6, 2, 'Фёдорова', 'Екатерина', 'Борисовна', '+79990006666', 'HR-менеджер', '2024-05-01', NULL, true),
(7, 4, 'Воробьёв', 'Андрей', 'Олегович', '+79990007777', 'Аналитик', '2024-06-01', NULL, true),
(8, 3, 'Григорьева', 'Ольга', 'Николаевна', '+79990008888', 'Контент-менеджер', '2024-01-15', NULL, true);

-- =====================================================
-- 5. Заполнение таблицы role_staff 
-- =====================================================
INSERT INTO my_schema.role_staff (id, staff_id, roleid, created_at) VALUES
(1, 1, 1, '2024-01-01 00:00:00+03'),  -- админ
(2, 2, 2, '2024-02-01 00:00:00+03'),  -- преподаватель
(3, 3, 4, '2024-03-01 00:00:00+03'),  -- модератор
(4, 4, 5, '2024-04-01 00:00:00+03'),  -- поддержка
(5, 5, 2, '2023-12-01 00:00:00+03'),  -- старший преподаватель
(6, 6, 8, '2024-05-01 00:00:00+03'),  -- HR
(7, 7, 6, '2024-06-01 00:00:00+03'),  -- аналитик
(8, 8, 7, '2024-01-15 00:00:00+03');  -- контент-менеджер

-- =====================================================
-- 6. Заполнение таблицы notification 
-- =====================================================
INSERT INTO my_schema.notification (id, code, topic, body_mask, is_active, addressee) VALUES
(1, 'COURSE_START', 'Курс начался', 'Курс {{course_name}} стартовал! Желаем успехов в обучении.', true, 'student'),
(2, 'HOMEWORK_ASSIGNED', 'Новое ДЗ', 'По курсу {{course_name}} добавлено домашнее задание "{{homework_title}}"', true, 'student'),
(3, 'HOMEWORK_GRADED', 'ДЗ проверено', 'Ваше ДЗ "{{homework_title}}" проверено. Оценка: {{grade}}', true, 'student'),
(4, 'PAYMENT_SUCCESS', 'Оплата прошла', 'Оплата {{amount}} руб. за курс {{course_name}} успешно проведена', true, 'student'),
(5, 'SYSTEM_ALERT', 'Системное уведомление', '{{message}}', true, 'all'),
(6, 'STAFF_MEETING', 'Совещание', 'Завтра в {{time}} состоится совещание', true, 'teacher'),
(7, 'CERTIFICATE_READY', 'Сертификат готов', 'Ваш сертификат по курсу {{course_name}} готов к скачиванию', true, 'student'),
(8, 'DEADLINE_REMINDER', 'Дедлайн приближается', 'До сдачи ДЗ "{{homework_title}}" осталось {{days}} дней', true, 'student'),
(9, 'PROMO_DISCOUNT', 'Скидка на курс', 'Для вас действует скидка {{discount}}% на курс {{course_name}}', true, 'all');

-- =====================================================
-- 7. Заполнение таблицы notification_dispatch 
-- =====================================================
INSERT INTO my_schema.notification_dispatch (id, entity_type, student_id, staff_id, dispatch_at, delivered, notifacation_id) VALUES
(1, 'student', 1, NULL, '2026-05-17 09:00:00+03', true, 1),
(2, 'student', 2, NULL, '2026-05-17 09:00:00+03', true, 1),
(3, 'student', 3, NULL, '2026-05-17 09:00:00+03', false, 1),
(4, 'student', 1, NULL, '2026-05-16 14:00:00+03', true, 2),
(5, 'student', 2, NULL, '2026-05-16 14:00:00+03', true, 2),
(6, 'teacher', NULL, 2, '2026-05-17 08:00:00+03', true, 6),
(7, 'all', NULL, NULL, '2026-05-17 10:00:00+03', false, 5),
(8, 'student', 5, NULL, '2026-05-17 11:00:00+03', true, 7),
(9, 'student', 6, NULL, '2026-05-17 12:00:00+03', false, 8),
(10, 'all', NULL, NULL, '2026-05-17 13:00:00+03', false, 9);

-- =====================================================
-- 8. Заполнение таблицы status 
-- =====================================================
INSERT INTO my_schema.status (id, name, description, update_at, state, entity_type) VALUES
(1, 'Новый', 'Только созданное обращение', '2026-05-17 00:00:00+03', 'open', 'ticket'),
(2, 'В работе', 'Обрабатывается сотрудником', '2026-05-17 00:00:00+03', 'in_progress', 'ticket'),
(3, 'Решён', 'Проблема решена', '2026-05-17 00:00:00+03', 'closed', 'ticket'),
(4, 'Закрыт', 'Обращение закрыто', '2026-05-17 00:00:00+03', 'closed', 'ticket'),
(5, 'Активен', 'Активный статус', '2026-05-17 00:00:00+03', 'active', 'default'),
(6, 'Заморожен', 'Временная блокировка', '2026-05-17 00:00:00+03', 'frozen', 'default'),
(7, 'Отменён', 'Отменён пользователем', '2026-05-17 00:00:00+03', 'cancelled', 'ticket'),
(8, 'Ожидает ответа', 'Ожидает ответа от пользователя', '2026-05-17 00:00:00+03', 'pending', 'ticket');

-- =====================================================
-- 9. Заполнение таблицы category 
-- =====================================================
INSERT INTO my_schema.category (id, name) VALUES
(1, 'Технические проблемы'),
(2, 'Вопросы по обучению'),
(3, 'Оплата и биллинг'),
(4, 'Предложение'),
(5, 'Жалоба'),
(6, 'Сертификаты'),
(7, 'Другое'),
(8, 'Промокоды и скидки');

-- =====================================================
-- 10. Заполнение таблицы ticket 
-- =====================================================
INSERT INTO my_schema.ticket (id, users_id, staff_id, category_id, description, created_at, closed_at, status_id) VALUES
(1, 1, 2, 2, 'Не открывается видео в курсе "Python для начинающих"', '2026-05-10 10:00:00+03', '2026-05-11 15:30:00+03', 3),
(2, 2, 3, 1, 'Не загружается домашнее задание, ошибка 500', '2026-05-12 11:00:00+03', '2026-05-13 14:00:00+03', 3),
(3, 3, 1, 3, 'Произошла двойная списание за курс', '2026-05-14 09:00:00+03', '2026-05-16 12:00:00+03', 2),
(4, 1, 2, 4, 'Предлагаю добавить тёмную тему в интерфейс', '2026-05-15 16:00:00+03', '2026-05-16 18:00:00+03', 4),
(5, 4, 2, 5, 'Не нравится качество преподавания', '2026-05-16 10:00:00+03', '2026-05-17 11:00:00+03', 3),
(6, 5, 4, 1, 'Не могу сбросить пароль', '2026-05-17 09:00:00+03', NULL, 2),
(7, 6, 3, 6, 'Когда будет готов сертификат?', '2026-05-17 10:00:00+03', NULL, 1),
(8, 7, 4, 7, 'Хочу предложить тему для нового курса', '2026-05-17 11:00:00+03', NULL, 1);

-- =====================================================
-- 11. Заполнение таблицы file 
-- =====================================================
INSERT INTO my_schema.file (id, name, type, created_at, size, link_FS, format, modification_at, staff_id, user_id) VALUES
(1, 'урок_1_видео', 'video', '2026-05-01 10:00:00+03', 15728640, '/files/lessons/lesson1.mp4', 'mp4', '2026-05-01 10:00:00+03', 2, 1),
(2, 'дз_иванов', 'document', '2026-05-10 14:00:00+03', 512000, '/files/homeworks/homework1.pdf', 'pdf', '2026-05-10 14:00:00+03', 1, 1),
(3, 'скрин_ошибки', 'image', '2026-05-12 11:30:00+03', 204800, '/files/tickets/screenshot1.png', 'png', '2026-05-12 11:30:00+03', 1, 2),
(4, 'договор_оплаты', 'document', '2026-05-14 09:00:00+03', 1048576, '/files/payments/invoice_123.pdf', 'pdf', '2026-05-14 09:00:00+03', 1, 3),
(5, 'презентация_курса', 'presentation', '2026-05-15 15:00:00+03', 5242880, '/files/courses/presentation.pptx', 'pptx', '2026-05-15 15:00:00+03', 2, 3),
(6, 'аватар_пользователя', 'image', '2026-05-16 10:00:00+03', 102400, '/files/avatars/avatar1.jpg', 'jpg', '2026-05-16 10:00:00+03', 3, 3),
(7, 'методичка', 'document', '2026-05-16 12:00:00+03', 2097152, '/files/materials/guide.pdf', 'pdf', '2026-05-16 12:00:00+03', 2, 4),
(8, 'видео_вебинара', 'video', '2026-05-17 08:00:00+03', 52428800, '/files/webinars/webinar1.mp4', 'mp4', '2026-05-17 08:00:00+03', 5, 5),
(9, 'домашнее_задание_мария', 'document', '2026-05-17 09:00:00+03', 256000, '/files/homeworks/homework2.docx', 'docx', '2026-05-17 09:00:00+03', 4, 2);

-- =====================================================
-- 12. Заполнение таблицы action_log 
-- =====================================================
INSERT INTO my_schema.action_log (id, user_id, created_at, action) VALUES
(1, 1, '2026-05-17 09:00:00+03', 'Авторизация в системе'),
(2, 1, '2026-05-17 09:15:00+03', 'Просмотр курса "Python для начинающих"'),
(3, 2, '2026-05-17 10:00:00+03', 'Загрузка домашнего задания'),
(4, 5, '2026-05-17 08:00:00+03', 'Создание нового курса "SQL для аналитиков"'),
(5, 2, '2026-05-17 11:00:00+03', 'Обновление профиля'),
(6, 3, '2026-05-17 11:30:00+03', 'Открытие обращения #1'),
(7, 6, '2026-05-17 12:00:00+03', 'Публикация объявления'),
(8, 7, '2026-05-17 13:00:00+03', 'Модерация комментария'),
(9, 1, '2026-05-17 14:00:00+03', 'Смена пароля'),
(10, 5, '2026-05-17 15:00:00+03', 'Выгрузка отчёта по студентам');

-- =====================================================
-- 13. Заполнение таблицы message 
-- =====================================================
INSERT INTO my_schema.message (id, ticket_id, user_id, staff_id, text, sent_at, file_id) VALUES
(1, 1, 1, 2, 'Здравствуйте, у меня не открывается видео в курсе', '2026-05-10 10:05:00+03', NULL),
(2, 1, 3, 2, 'Здравствуйте, проверьте, пожалуйста, обновите страницу', '2026-05-10 11:00:00+03', NULL),
(3, 1, 1, 3, 'Спасибо, помогло!', '2026-05-10 11:30:00+03', NULL),
(4, 2, 2, 1, 'Ошибка 500 при загрузке ДЗ, скрин прилагаю', '2026-05-12 11:05:00+03', 3),
(5, 2, 3, 3, 'Проблема передана техническому специалисту', '2026-05-12 12:00:00+03', NULL),
(6, 3, 3, 4, 'Списали деньги дважды за один курс', '2026-05-14 09:10:00+03', 4),
(7, 3, 5, 1, 'Проверяем информацию, ожидайте', '2026-05-14 10:00:00+03', NULL),
(8, 3, 5, 1, 'Возврат средств инициирован, деньги поступят через 3-5 дней', '2026-05-15 14:00:00+03', NULL),
(9, 6, 5, 4, 'Не могу сбросить пароль, приходит ошибка', '2026-05-17 09:10:00+03', NULL),
(10, 6, 4, 4, 'Отправили ссылку для сброса на почту', '2026-05-17 09:30:00+03', NULL);



