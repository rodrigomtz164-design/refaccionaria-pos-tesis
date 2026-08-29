-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: refaccionaria_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add categoria',6,'add_categoria'),(22,'Can change categoria',6,'change_categoria'),(23,'Can delete categoria',6,'delete_categoria'),(24,'Can view categoria',6,'view_categoria'),(25,'Can add marca auto',10,'add_marcaauto'),(26,'Can change marca auto',10,'change_marcaauto'),(27,'Can delete marca auto',10,'delete_marcaauto'),(28,'Can view marca auto',10,'view_marcaauto'),(29,'Can add proveedor',13,'add_proveedor'),(30,'Can change proveedor',13,'change_proveedor'),(31,'Can delete proveedor',13,'delete_proveedor'),(32,'Can view proveedor',13,'view_proveedor'),(33,'Can add rol',14,'add_rol'),(34,'Can change rol',14,'change_rol'),(35,'Can delete rol',14,'delete_rol'),(36,'Can view rol',14,'view_rol'),(37,'Can add user',15,'add_usuario'),(38,'Can change user',15,'change_usuario'),(39,'Can delete user',15,'delete_usuario'),(40,'Can view user',15,'view_usuario'),(41,'Can add cotizacion',7,'add_cotizacion'),(42,'Can change cotizacion',7,'change_cotizacion'),(43,'Can delete cotizacion',7,'delete_cotizacion'),(44,'Can view cotizacion',7,'view_cotizacion'),(45,'Can add log auditoria',9,'add_logauditoria'),(46,'Can change log auditoria',9,'change_logauditoria'),(47,'Can delete log auditoria',9,'delete_logauditoria'),(48,'Can view log auditoria',9,'view_logauditoria'),(49,'Can add modelo auto',11,'add_modeloauto'),(50,'Can change modelo auto',11,'change_modeloauto'),(51,'Can delete modelo auto',11,'delete_modeloauto'),(52,'Can view modelo auto',11,'view_modeloauto'),(53,'Can add producto',12,'add_producto'),(54,'Can change producto',12,'change_producto'),(55,'Can delete producto',12,'delete_producto'),(56,'Can view producto',12,'view_producto'),(57,'Can add venta',16,'add_venta'),(58,'Can change venta',16,'change_venta'),(59,'Can delete venta',16,'delete_venta'),(60,'Can view venta',16,'view_venta'),(61,'Can add detalle venta',8,'add_detalleventa'),(62,'Can change detalle venta',8,'change_detalleventa'),(63,'Can delete detalle venta',8,'delete_detalleventa'),(64,'Can view detalle venta',8,'view_detalleventa'),(65,'Can add detalle cotizacion',17,'add_detallecotizacion'),(66,'Can change detalle cotizacion',17,'change_detallecotizacion'),(67,'Can delete detalle cotizacion',17,'delete_detallecotizacion'),(68,'Can view detalle cotizacion',17,'view_detallecotizacion'),(69,'Can add lista precio proveedor',18,'add_listaprecioproveedor'),(70,'Can change lista precio proveedor',18,'change_listaprecioproveedor'),(71,'Can delete lista precio proveedor',18,'delete_listaprecioproveedor'),(72,'Can view lista precio proveedor',18,'view_listaprecioproveedor'),(73,'Can add descuento config',20,'add_descuentoconfig'),(74,'Can change descuento config',20,'change_descuentoconfig'),(75,'Can delete descuento config',20,'delete_descuentoconfig'),(76,'Can view descuento config',20,'view_descuentoconfig'),(77,'Can add corte caja',19,'add_cortecaja'),(78,'Can change corte caja',19,'change_cortecaja'),(79,'Can delete corte caja',19,'delete_cortecaja'),(80,'Can view corte caja',19,'view_cortecaja');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8mb4_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_sistema_usuario_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_sistema_usuario_id` FOREIGN KEY (`user_id`) REFERENCES `sistema_usuario` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-07-31 02:52:00.381543','1','Administrador',1,'[{\"added\": {}}]',14,1),(2,'2026-07-31 02:52:16.336764','2','Almacenista',1,'[{\"added\": {}}]',14,1),(3,'2026-07-31 02:52:29.586440','3','Vendedor',1,'[{\"added\": {}}]',14,1),(4,'2026-08-01 02:50:58.805390','2','dianita - Vendedor',1,'[{\"added\": {}}]',15,1),(5,'2026-08-01 02:51:46.219034','3','migue - Almacenista',1,'[{\"added\": {}}]',15,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'contenttypes','contenttype'),(5,'sessions','session'),(6,'sistema','categoria'),(19,'sistema','cortecaja'),(7,'sistema','cotizacion'),(20,'sistema','descuentoconfig'),(17,'sistema','detallecotizacion'),(8,'sistema','detalleventa'),(18,'sistema','listaprecioproveedor'),(9,'sistema','logauditoria'),(10,'sistema','marcaauto'),(11,'sistema','modeloauto'),(12,'sistema','producto'),(13,'sistema','proveedor'),(14,'sistema','rol'),(15,'sistema','usuario'),(16,'sistema','venta');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-07-31 02:28:42.801432'),(2,'contenttypes','0002_remove_content_type_name','2026-07-31 02:28:42.978387'),(3,'auth','0001_initial','2026-07-31 02:28:43.447703'),(4,'auth','0002_alter_permission_name_max_length','2026-07-31 02:28:43.548885'),(5,'auth','0003_alter_user_email_max_length','2026-07-31 02:28:43.558569'),(6,'auth','0004_alter_user_username_opts','2026-07-31 02:28:43.569695'),(7,'auth','0005_alter_user_last_login_null','2026-07-31 02:28:43.580406'),(8,'auth','0006_require_contenttypes_0002','2026-07-31 02:28:43.584635'),(9,'auth','0007_alter_validators_add_error_messages','2026-07-31 02:28:43.597188'),(10,'auth','0008_alter_user_username_max_length','2026-07-31 02:28:43.609614'),(11,'auth','0009_alter_user_last_name_max_length','2026-07-31 02:28:43.625530'),(12,'auth','0010_alter_group_name_max_length','2026-07-31 02:28:43.659489'),(13,'auth','0011_update_proxy_permissions','2026-07-31 02:28:43.673548'),(14,'auth','0012_alter_user_first_name_max_length','2026-07-31 02:28:43.685915'),(15,'sistema','0001_initial','2026-07-31 02:28:46.611903'),(16,'admin','0001_initial','2026-07-31 02:28:46.892122'),(17,'admin','0002_logentry_remove_auto_add','2026-07-31 02:28:46.905775'),(18,'admin','0003_logentry_add_action_flag_choices','2026-07-31 02:28:46.923769'),(19,'sessions','0001_initial','2026-07-31 02:28:46.995631'),(20,'sistema','0002_producto_unidad_medida_alter_detalleventa_cantidad_and_more','2026-07-31 03:44:19.526430'),(21,'sistema','0003_cotizacion_cliente_telefono_cotizacion_estado_and_more','2026-08-01 01:40:41.590393'),(22,'sistema','0004_listaprecioproveedor_producto_activo','2026-08-03 21:29:36.873339'),(23,'sistema','0005_descuentoconfig_cotizacion_cliente_email_and_more','2026-08-19 09:00:38.261084');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('9mqwn0rp9c6fnunnxlpcroyu61nj7fnp','.eJxVjEEKwyAQAP-y5yIq6mqOvfcNsupa0xYDMTmV_r0EcmivM8O8IdK-tbgPXuNcYAIFl1-WKD-5H6I8qN8XkZe-rXMSRyJOO8RtKfy6nu3foNFoMIFjksTVZE1JMVkftEVNWL0r1ZHxRVfvPVojtaGUAyKykQoDG20R4fMF9eo3jQ:1wyZpS:VPWEYOc8pLCbovnpehcZFO-Mo7p5GKH2Y3HUmnXOXwI','2026-09-07 18:55:30.439333');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_categoria`
--

DROP TABLE IF EXISTS `sistema_categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_categoria` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_categoria`
--

LOCK TABLES `sistema_categoria` WRITE;
/*!40000 ALTER TABLE `sistema_categoria` DISABLE KEYS */;
INSERT INTO `sistema_categoria` VALUES (1,'Frenos','Balatas, discos, tambores'),(2,'Aceites y Fluídos','Aceites de motor, anticongelantes, granel'),(3,'Filtros','Filtros de aire, aceite y gasolina'),(4,'Suspensión y Dirección','Amortiguadores, rótulas, terminales, bujes'),(5,'Encendido y Eléctrico','Bujías, cables, bobinas, marchas, alternadores'),(6,'Motor y Enfriamiento','Bombas de agua, bandas, termostatos, empaques'),(7,'herramientas',NULL);
/*!40000 ALTER TABLE `sistema_categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_cortecaja`
--

DROP TABLE IF EXISTS `sistema_cortecaja`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_cortecaja` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_cierre` datetime(6) NOT NULL,
  `total_cobrado` decimal(10,2) NOT NULL,
  `num_ventas` int NOT NULL,
  `observaciones` longtext COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sistema_cortecaja_usuario_id_c9437838_fk_sistema_usuario_id` (`usuario_id`),
  CONSTRAINT `sistema_cortecaja_usuario_id_c9437838_fk_sistema_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `sistema_usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_cortecaja`
--

LOCK TABLES `sistema_cortecaja` WRITE;
/*!40000 ALTER TABLE `sistema_cortecaja` DISABLE KEYS */;
INSERT INTO `sistema_cortecaja` VALUES (1,'2026-08-19 09:11:03.239661',8570.70,14,'',1),(2,'2026-08-24 06:35:02.315775',2922.70,5,'corte de caja del turno de la tarde',2),(3,'2026-08-24 18:54:53.508397',1053.60,2,'corte de caja de turno mañana',2);
/*!40000 ALTER TABLE `sistema_cortecaja` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_cotizacion`
--

DROP TABLE IF EXISTS `sistema_cotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_cotizacion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cliente_nombre` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `vendedor_id` bigint NOT NULL,
  `cliente_telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `cliente_email` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sistema_cotizacion_vendedor_id_4af71b87_fk_sistema_usuario_id` (`vendedor_id`),
  CONSTRAINT `sistema_cotizacion_vendedor_id_4af71b87_fk_sistema_usuario_id` FOREIGN KEY (`vendedor_id`) REFERENCES `sistema_usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_cotizacion`
--

LOCK TABLES `sistema_cotizacion` WRITE;
/*!40000 ALTER TABLE `sistema_cotizacion` DISABLE KEYS */;
INSERT INTO `sistema_cotizacion` VALUES (1,'pedro porro','2026-08-01 02:05:42.702547',560.00,1,'5512345678','VENCIDA',560.00,NULL),(2,'javier santana','2026-08-01 09:14:36.487474',280.00,2,'5618213785','VENCIDA',280.00,NULL),(3,'arturo','2026-08-01 09:43:39.588203',1420.00,1,'57808570','CONVERTIDA',1420.00,NULL),(4,'lorenzo','2026-08-03 20:32:47.891669',840.00,1,'4567028755','CONVERTIDA',840.00,NULL),(5,'Nicolas','2026-08-04 02:16:02.331529',1500.00,2,'','VENCIDA',1500.00,NULL),(6,'jorge','2026-08-04 02:34:15.218099',1020.00,2,'5572346512','VENCIDA',1020.00,NULL),(9,'Liliana','2026-08-04 02:51:21.882702',384.00,2,'','CONVERTIDA',384.00,NULL),(10,'Javier','2026-08-04 03:00:44.112012',225.00,1,'','CONVERTIDA',225.00,NULL),(11,'Cliente Mostrador','2026-08-17 19:23:17.468562',685.00,2,'','VENCIDA',685.00,NULL),(12,'Cliente Mostrador','2026-08-17 19:26:59.107277',1460.00,2,'','VENCIDA',1460.00,NULL),(13,'roman','2026-08-19 08:29:10.771965',280.00,1,'553553663','CONVERTIDA',280.00,NULL),(14,'alis','2026-08-19 08:48:17.514948',210.00,1,'32413123','CONVERTIDA',210.00,NULL),(15,'Cliente Mostrador','2026-08-20 19:56:49.686773',125.00,1,'','CONVERTIDA',125.00,NULL),(16,'Cliente Mostrador','2026-08-20 20:20:53.216204',485.00,1,'','VENCIDA',485.00,NULL),(17,'Cliente Mostrador','2026-08-24 05:56:44.145963',1092.50,2,'','CONVERTIDA',1150.00,NULL),(18,'Cliente Mostrador','2026-08-24 18:47:19.386473',561.60,1,'','CONVERTIDA',585.00,NULL);
/*!40000 ALTER TABLE `sistema_cotizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_descuentoconfig`
--

DROP TABLE IF EXISTS `sistema_descuentoconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_descuentoconfig` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `porcentaje` int NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_descuentoconfig`
--

LOCK TABLES `sistema_descuentoconfig` WRITE;
/*!40000 ALTER TABLE `sistema_descuentoconfig` DISABLE KEYS */;
INSERT INTO `sistema_descuentoconfig` VALUES (1,'Descuento Mostrador',7,1),(2,'Descuento Medio',4,1),(3,'Descuento Taller',10,0),(4,'Descuento Especial',12,0),(5,'aniversario',50,1);
/*!40000 ALTER TABLE `sistema_descuentoconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_detallecotizacion`
--

DROP TABLE IF EXISTS `sistema_detallecotizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_detallecotizacion` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` decimal(10,2) NOT NULL,
  `precio_cotizado` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `cotizacion_id` bigint NOT NULL,
  `producto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sistema_detallecotiz_cotizacion_id_04740b53_fk_sistema_c` (`cotizacion_id`),
  KEY `sistema_detallecotiz_producto_id_919e6db3_fk_sistema_p` (`producto_id`),
  CONSTRAINT `sistema_detallecotiz_cotizacion_id_04740b53_fk_sistema_c` FOREIGN KEY (`cotizacion_id`) REFERENCES `sistema_cotizacion` (`id`),
  CONSTRAINT `sistema_detallecotiz_producto_id_919e6db3_fk_sistema_p` FOREIGN KEY (`producto_id`) REFERENCES `sistema_producto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_detallecotizacion`
--

LOCK TABLES `sistema_detallecotizacion` WRITE;
/*!40000 ALTER TABLE `sistema_detallecotizacion` DISABLE KEYS */;
INSERT INTO `sistema_detallecotizacion` VALUES (1,2.00,280.00,560.00,1,1),(2,1.00,280.00,280.00,2,1),(3,1.00,280.00,280.00,3,1),(4,3.00,380.00,1140.00,3,4),(5,3.00,280.00,840.00,4,1),(6,1.00,384.00,384.00,9,178),(7,3.00,75.00,225.00,10,2),(8,1.00,95.00,95.00,11,3),(9,1.00,380.00,380.00,11,4),(10,1.00,210.00,210.00,11,7),(11,1.00,95.00,95.00,12,3),(12,1.00,380.00,380.00,12,4),(13,1.00,210.00,210.00,12,7),(14,1.00,45.00,45.00,12,48),(15,1.00,550.00,550.00,12,55),(16,1.00,180.00,180.00,12,64),(17,1.00,280.00,280.00,13,17),(18,2.00,105.00,210.00,14,44),(19,1.00,125.00,125.00,15,45),(20,1.00,125.00,125.00,16,45),(21,1.00,360.00,360.00,16,5),(25,1.00,460.00,460.00,17,12),(26,1.00,240.00,240.00,17,6),(27,1.00,450.00,450.00,17,9),(31,1.00,270.00,270.00,18,10),(32,1.00,75.00,75.00,18,2),(33,1.00,240.00,240.00,18,6);
/*!40000 ALTER TABLE `sistema_detallecotizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_detalleventa`
--

DROP TABLE IF EXISTS `sistema_detalleventa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_detalleventa` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cantidad` decimal(10,2) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `producto_id` bigint NOT NULL,
  `venta_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sistema_detalleventa_producto_id_397b713b_fk_sistema_producto_id` (`producto_id`),
  KEY `sistema_detalleventa_venta_id_f2cb0ea5_fk_sistema_venta_id` (`venta_id`),
  CONSTRAINT `sistema_detalleventa_producto_id_397b713b_fk_sistema_producto_id` FOREIGN KEY (`producto_id`) REFERENCES `sistema_producto` (`id`),
  CONSTRAINT `sistema_detalleventa_venta_id_f2cb0ea5_fk_sistema_venta_id` FOREIGN KEY (`venta_id`) REFERENCES `sistema_venta` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_detalleventa`
--

LOCK TABLES `sistema_detalleventa` WRITE;
/*!40000 ALTER TABLE `sistema_detalleventa` DISABLE KEYS */;
INSERT INTO `sistema_detalleventa` VALUES (1,2.00,280.00,560.00,1,1),(2,2.00,280.00,560.00,1,2),(3,2.00,280.00,560.00,1,3),(4,2.00,380.00,760.00,4,4),(5,1.00,280.00,280.00,1,5),(6,3.00,380.00,1140.00,4,5),(7,1.00,280.00,280.00,1,6),(8,1.00,380.00,380.00,4,6),(9,3.00,280.00,840.00,1,7),(10,4.00,380.00,1520.00,4,8),(11,3.00,75.00,225.00,2,10),(12,1.00,145.00,145.00,84,11),(13,2.00,110.00,220.00,36,11),(14,1.00,280.00,280.00,17,12),(15,2.00,105.00,210.00,44,13),(16,2.00,280.00,560.00,1,14),(17,1.00,125.00,125.00,45,15),(18,1.00,210.00,210.00,7,15),(19,1.00,450.00,450.00,9,16),(20,1.00,260.00,260.00,52,17),(21,1.00,360.00,360.00,5,17),(22,1.00,95.00,95.00,3,17),(23,1.00,320.00,320.00,16,18),(24,2.00,75.00,150.00,2,18),(25,1.00,460.00,460.00,12,19),(26,1.00,240.00,240.00,6,19),(27,1.00,450.00,450.00,9,19),(28,1.00,270.00,270.00,10,20),(29,1.00,75.00,75.00,2,20),(30,1.00,240.00,240.00,6,20),(31,4.10,120.00,492.00,46,21);
/*!40000 ALTER TABLE `sistema_detalleventa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_listaprecioproveedor`
--

DROP TABLE IF EXISTS `sistema_listaprecioproveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_listaprecioproveedor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `proveedor_negocio` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_refaccion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre_refaccion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `precio_referencia` decimal(10,2) NOT NULL,
  `telefono_contacto` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notas` longtext COLLATE utf8mb4_unicode_ci,
  `fecha_actualizacion` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_listaprecioproveedor`
--

LOCK TABLES `sistema_listaprecioproveedor` WRITE;
/*!40000 ALTER TABLE `sistema_listaprecioproveedor` DISABLE KEYS */;
INSERT INTO `sistema_listaprecioproveedor` VALUES (1,'AutoZone Sur','AM-8821','Amortiguador Delantero Sentra 2018',850.00,'5512345678','Garantia de 1 ano','2026-08-04 01:22:34.212933'),(2,'Honda Central','DIS-304','Disco de Freno Ventilado Civic 2020',1250.00,'5598765432','Pieza original de agencia','2026-08-04 01:22:34.249091'),(3,'Refaccionaria El Piston','BMB-102','Bomba de Agua Tsuru III 1.6L',320.00,'5544332211','Incluye empaque de colador','2026-08-04 01:22:34.256339');
/*!40000 ALTER TABLE `sistema_listaprecioproveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_logauditoria`
--

DROP TABLE IF EXISTS `sistema_logauditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_logauditoria` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `accion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_hora` datetime(6) NOT NULL,
  `detalles` longtext COLLATE utf8mb4_unicode_ci,
  `usuario_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sistema_logauditoria_usuario_id_9ef01895_fk_sistema_usuario_id` (`usuario_id`),
  CONSTRAINT `sistema_logauditoria_usuario_id_9ef01895_fk_sistema_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `sistema_usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_logauditoria`
--

LOCK TABLES `sistema_logauditoria` WRITE;
/*!40000 ALTER TABLE `sistema_logauditoria` DISABLE KEYS */;
INSERT INTO `sistema_logauditoria` VALUES (1,'Venta registrada #1','2026-08-01 01:13:38.259870','Total: $560.00 | Descuento: 0.0%',1),(2,'Edición de Producto #1 (BAL-TSU-01)','2026-08-01 01:37:47.078126','Precio: $280.00 -> $280 | Stock: 10.00 -> 15',1),(3,'Cotización generada #1','2026-08-01 02:05:42.709020','Cliente: pedro porro | Total: $560.00',1),(4,'Venta registrada #2','2026-08-01 02:27:36.382902','Total: $532.00 | Descuento: 5.0%',1),(5,'Cotización generada #2','2026-08-01 09:14:36.524014','Cliente: javier santana | Total: $280.00',2),(6,'Venta registrada #3','2026-08-01 09:15:38.362048','Total: $532.00 | Descuento: 5.0%',2),(7,'Venta registrada #4','2026-08-01 09:42:09.687926','Total: $699.20 | Descuento: 8.0%',1),(8,'Cotización generada #3','2026-08-01 09:43:39.601282','Cliente: arturo | Total: $1420.00',1),(9,'Venta registrada #5','2026-08-01 09:44:59.417351','Total: $1420.00 | Descuento: 0.0%',1),(10,'Venta registrada #6','2026-08-01 10:01:16.930076','Total: $660.00 | Descuento: 0.0%',1),(11,'Edición de Producto #1 (BAL-TSU-01)','2026-08-03 20:29:05.930388','Precio: $280.00 -> $280 | Stock: 9.00 -> 13',3),(12,'Edición de Producto #4 (BAL-VER-01)','2026-08-03 20:29:14.563153','Precio: $380.00 -> $380 | Stock: 9.00 -> 14',3),(13,'Cotización generada #4','2026-08-03 20:32:47.893836','Cliente: lorenzo | Total: $840.00',1),(14,'Venta registrada #7','2026-08-03 20:33:24.518068','Total: $798.00 | Descuento: 5.0%',1),(15,'Venta registrada #8','2026-08-03 20:36:49.212966','Total: $1398.40 | Descuento: 8.0%',2),(16,'Cambio de Estado Producto #1','2026-08-03 22:05:01.976966','El producto \'Balatas Delanteras Tsuru III\' (SKU: BAL-TSU-01) fue DESACTIVADO.',1),(17,'Cambio de Estado Producto #1','2026-08-03 22:05:04.243803','El producto \'Balatas Delanteras Tsuru III\' (SKU: BAL-TSU-01) fue ACTIVADO.',1),(18,'Cambio de Estado Producto #1','2026-08-03 22:05:05.894440','El producto \'Balatas Delanteras Tsuru III\' (SKU: BAL-TSU-01) fue DESACTIVADO.',1),(19,'Cambio de Estado Producto #1','2026-08-03 22:05:07.190082','El producto \'Balatas Delanteras Tsuru III\' (SKU: BAL-TSU-01) fue ACTIVADO.',1),(20,'Cambio de Estado Producto #4','2026-08-03 23:07:21.547653','El producto \'Balata Delantera Versa 1.6L (2012-2022)\' (SKU: BAL-VER-01) fue DESACTIVADO.',1),(21,'Cambio de Estado Producto #4','2026-08-03 23:07:22.493348','El producto \'Balata Delantera Versa 1.6L (2012-2022)\' (SKU: BAL-VER-01) fue ACTIVADO.',1),(22,'Carga Masiva Excel Proveedores','2026-08-04 01:21:53.970398','Se procesaron 3 registros (3 creados, 0 actualizados).',1),(23,'Carga Masiva Excel Proveedores','2026-08-04 01:22:34.262527','Se procesaron 3 registros (0 creados, 3 actualizados).',1),(24,'Cotización generada #5','2026-08-04 02:16:02.339790','Cliente: Nicolas | Total: $1500.00',2),(25,'Cotización generada #6','2026-08-04 02:34:15.253474','Cliente: jorge | Total: $1020.00',2),(26,'Cotización generada #9','2026-08-04 02:51:21.885995','Cliente: Liliana | Total: $384.00',2),(27,'Venta registrada #9','2026-08-04 02:52:22.942769','Total: $364.80 | Descuento: 5.0%',2),(28,'Cotización generada #10','2026-08-04 03:00:44.114129','Cliente: Javier | Total: $225.00',1),(29,'Venta registrada #10','2026-08-04 03:02:24.391518','Total: $220.50 | Descuento: 2.0%',1),(30,'Cambio de Estado Producto #6','2026-08-04 03:04:03.377892','El producto \'Balata Delantera Chevy C1 C2 C3 (1994-2012)\' (SKU: BAL-CHE-03) fue DESACTIVADO.',1),(31,'Cambio de Estado Producto #6','2026-08-04 03:04:05.080231','El producto \'Balata Delantera Chevy C1 C2 C3 (1994-2012)\' (SKU: BAL-CHE-03) fue ACTIVADO.',1),(32,'Venta registrada #11','2026-08-17 18:53:34.493105','Total: $335.80 | Descuento: 8.0%',1),(33,'Cotización generada #11','2026-08-17 19:23:17.472899','Cliente: Cliente Mostrador | Total: $685.00',2),(34,'Cotización generada #12','2026-08-17 19:26:59.126801','Cliente: Cliente Mostrador | Total: $1460.00',2),(35,'Cotización generada #13','2026-08-19 08:29:10.892175','Cliente: roman | Total: $280.00',1),(36,'Venta registrada #12','2026-08-19 08:33:42.294856','Total: $280.00 | Descuento: 0.0%',1),(37,'Cotización generada #14','2026-08-19 08:48:17.563058','Cliente: alis | Total: $210.00',1),(38,'Venta registrada #13','2026-08-19 08:49:03.292839','Total: $210.00 | Descuento: 0.0%',1),(39,'Consulta de Corte de Caja','2026-08-19 08:49:13.283954','Corte del día 19/08/2026: 2 ventas por un total de $490.00.',1),(40,'Consulta de Corte de Caja','2026-08-19 08:49:27.501371','Corte del día 19/08/2026: 2 ventas por un total de $490.00.',1),(41,'Consulta de Corte de Caja','2026-08-19 08:54:26.697245','Corte del día 19/08/2026: 2 ventas por un total de $490.00.',1),(42,'Consulta de Corte de Caja','2026-08-19 08:54:42.104125','Corte del día 19/08/2026: 2 ventas por un total de $490.00.',1),(43,'Venta registrada #14','2026-08-19 09:09:57.913832','Total: $560.00 | Descuento: 0.0%',1),(44,'Cierre de Caja #1','2026-08-19 09:11:03.246851','Corte realizado por paddys. Total: $8570.70 con 14 ventas liquidadas.',1),(45,'Actualización de Descuentos POS','2026-08-19 09:19:03.985616','Se modificaron los porcentajes de descuento habilitados para los vendedores.',1),(46,'Actualización de Descuentos POS','2026-08-19 09:19:26.542844','Se modificaron los porcentajes de descuento habilitados para los vendedores.',1),(47,'Actualización de Descuentos POS','2026-08-19 09:22:39.077653','Se modificaron los porcentajes de descuento habilitados para los vendedores.',1),(48,'Actualización de Descuentos POS','2026-08-19 09:31:47.556147','Se modificaron los porcentajes de descuento habilitados para los vendedores.',1),(49,'Cambio de Estado Producto #6','2026-08-19 09:56:00.440451','El producto \'Balata Delantera Chevy C1 C2 C3 (1994-2012)\' (SKU: BAL-CHE-03) fue DESACTIVADO.',1),(50,'Cambio de Estado Producto #6','2026-08-19 09:56:02.132670','El producto \'Balata Delantera Chevy C1 C2 C3 (1994-2012)\' (SKU: BAL-CHE-03) fue ACTIVADO.',1),(51,'Cotización generada #15','2026-08-20 19:56:49.714366','Cliente: Cliente Mostrador (Sin email) | Total: $125.00',1),(52,'Cotización generada #16','2026-08-20 20:20:53.223616','Cliente: Cliente Mostrador (Sin email) | Total: $485.00',1),(53,'Venta registrada #15','2026-08-20 20:22:59.895800','Total: $335.00 | Descuento: 0.0%',1),(54,'Actualización de Niveles de Descuento','2026-08-24 04:07:46.501180','Se modificaron nombres, porcentajes y estados de descuentos del POS.',1),(55,'Actualización de Niveles de Descuento','2026-08-24 04:07:46.504684','Se modificaron nombres, porcentajes y estados de descuentos del POS.',1),(56,'Actualización de Niveles de Descuento','2026-08-24 04:07:51.180718','Se modificaron nombres, porcentajes y estados de descuentos del POS.',1),(57,'Venta registrada #16','2026-08-24 04:09:26.191770','Total: $396.00 | Descuento: 12.0%',2),(58,'Venta registrada #17','2026-08-24 04:42:20.382221','Total: $629.20 | Descuento: 12.0%',2),(59,'Venta registrada #18','2026-08-24 04:49:09.595399','Total: $470.00 | Descuento: 0.0%',2),(60,'Cotización generada #17','2026-08-24 05:56:44.165623','Cliente: Cliente Mostrador | Total: $460.00',2),(61,'Cotización actualizada #17','2026-08-24 05:57:42.035507','Se actualizaron refacciones de #17 | Nuevo Total: $700.00',2),(62,'Venta registrada #19','2026-08-24 05:58:26.998143','Total: $1092.50 | Descuento: 5.0%',2),(63,'Cierre de Caja #2','2026-08-24 06:35:02.338241','Corte #2 realizado por dianita. Total: $2922.70 (5 notas). [Autorizado por Admin: paddys]',2),(64,'Creación de Categoría','2026-08-24 07:06:21.561867','Se creó la línea de producto \'herramientas\'.',3),(65,'Actualización de Niveles de Descuento','2026-08-24 08:10:32.772469','Se modificaron nombres, porcentajes y estados de descuentos del POS.',1),(66,'Cotización generada #18','2026-08-24 18:47:19.388805','Cliente: Cliente Mostrador | Total: $270.00',1),(67,'Cotización actualizada #18','2026-08-24 18:47:58.034786','Se actualizaron refacciones de #18 | Nuevo Total: $345.00',1),(68,'Venta registrada #20','2026-08-24 18:48:23.891065','Total: $561.60 | Descuento: 4.0%',1),(69,'Creación de Nivel de Descuento','2026-08-24 18:49:35.058049','Nuevo descuento \'aniversario\' al 50%.',1),(70,'Actualización de Niveles de Descuento','2026-08-24 18:49:40.583454','Se modificaron nombres, porcentajes y estados de descuentos del POS.',1),(71,'Venta registrada #21','2026-08-24 18:53:07.499819','Total: $492.00 | Descuento: 0.0%',2),(72,'Cierre de Caja #3','2026-08-24 18:54:53.510871','Corte #3 realizado por dianita. Total: $1053.60 (2 notas). [Autorizado por Admin: paddys]',2);
/*!40000 ALTER TABLE `sistema_logauditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_marcaauto`
--

DROP TABLE IF EXISTS `sistema_marcaauto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_marcaauto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_marcaauto`
--

LOCK TABLES `sistema_marcaauto` WRITE;
/*!40000 ALTER TABLE `sistema_marcaauto` DISABLE KEYS */;
INSERT INTO `sistema_marcaauto` VALUES (2,'Chevrolet'),(4,'Ford'),(7,'Hyundai'),(6,'Kia'),(1,'Nissan'),(8,'Suzuki'),(5,'Toyota'),(3,'Volkswagen');
/*!40000 ALTER TABLE `sistema_marcaauto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_modeloauto`
--

DROP TABLE IF EXISTS `sistema_modeloauto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_modeloauto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `anio_inicio` int NOT NULL,
  `anio_fin` int NOT NULL,
  `marca_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sistema_modeloauto_marca_id_nombre_anio_ini_4ff8e264_uniq` (`marca_id`,`nombre`,`anio_inicio`,`anio_fin`),
  CONSTRAINT `sistema_modeloauto_marca_id_a3afd2a6_fk_sistema_marcaauto_id` FOREIGN KEY (`marca_id`) REFERENCES `sistema_marcaauto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_modeloauto`
--

LOCK TABLES `sistema_modeloauto` WRITE;
/*!40000 ALTER TABLE `sistema_modeloauto` DISABLE KEYS */;
INSERT INTO `sistema_modeloauto` VALUES (5,'D21 / PickUp',0,0,1),(3,'March',0,0,1),(6,'NP300',0,0,1),(4,'Sentra',0,0,1),(1,'Tsuru III',1992,2017,1),(8,'Aveo',0,0,2),(2,'Aveo',2008,2018,2),(7,'Chevy',0,0,2),(10,'Corsa / Tornado',0,0,2),(9,'Spark / Beat',0,0,2),(14,'Golf',0,0,3),(12,'Jetta A4 / Clásico',0,0,3),(13,'Pointer',0,0,3),(11,'Vocho Sedan',0,0,3),(15,'Figo',0,0,4),(16,'Ranger',0,0,4),(17,'Hilux',0,0,5),(18,'Rio',0,0,6),(19,'Accent',0,0,7),(20,'Swift',0,0,8);
/*!40000 ALTER TABLE `sistema_modeloauto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_producto`
--

DROP TABLE IF EXISTS `sistema_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_producto` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sku` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci,
  `precio_costo` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `stock_actual` decimal(10,2) NOT NULL,
  `stock_minimo` decimal(10,2) NOT NULL,
  `es_granel` tinyint(1) NOT NULL,
  `fecha_creacion` datetime(6) NOT NULL,
  `categoria_id` bigint NOT NULL,
  `proveedor_id` bigint DEFAULT NULL,
  `unidad_medida` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sku` (`sku`),
  KEY `sistema_producto_categoria_id_d36b8ea7_fk_sistema_categoria_id` (`categoria_id`),
  KEY `sistema_producto_proveedor_id_ed81a874_fk_sistema_proveedor_id` (`proveedor_id`),
  CONSTRAINT `sistema_producto_categoria_id_d36b8ea7_fk_sistema_categoria_id` FOREIGN KEY (`categoria_id`) REFERENCES `sistema_categoria` (`id`),
  CONSTRAINT `sistema_producto_proveedor_id_ed81a874_fk_sistema_proveedor_id` FOREIGN KEY (`proveedor_id`) REFERENCES `sistema_proveedor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=179 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_producto`
--

LOCK TABLES `sistema_producto` WRITE;
/*!40000 ALTER TABLE `sistema_producto` DISABLE KEYS */;
INSERT INTO `sistema_producto` VALUES (1,'BAL-TSU-01','Balatas Delanteras Tsuru III','Juego de balatas cerámicas delanteras',180.00,280.00,8.00,3.00,0,'2026-07-31 08:18:58.994319',1,1,'Pieza',1),(2,NULL,'Aceite 20W-50 Multigrado (Suelto/Granel)','Aceite de motor despachado por litro',45.00,75.00,44.50,10.00,1,'2026-07-31 08:18:59.050060',2,1,'Litro',1),(3,'FIL-AVE-99','Filtro de Aceite Aveo 1.6L','Filtro blindado de aceite sintético',50.00,95.00,1.00,5.00,0,'2026-07-31 08:18:59.064240',3,1,'Pieza',1),(4,'BAL-VER-01','Balata Delantera Versa 1.6L (2012-2022)','Cerámica alta fricción',220.00,380.00,10.00,3.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(5,'BAL-MAR-02','Balata Delantera March 1.6L (2012-2023)','Cerámica equipo original',210.00,360.00,9.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(6,'BAL-CHE-03','Balata Delantera Chevy C1 C2 C3 (1994-2012)','Semimetálica reforzada',140.00,240.00,18.00,4.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(7,'BAL-VOC-04','Balata Delantera Vocho Sedan 1600 (1974-2004)','Tambor/Disco según versión',120.00,210.00,17.00,4.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(8,'BAL-AV2-05','Balata Delantera Aveo NG (2018-2024)','Cerámica premium',250.00,420.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(9,'BAL-RIO-06','Balata Delantera Kia Rio / Accent (2018-2023)','Cerámica sin ruido',260.00,450.00,10.00,3.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(10,'BAL-TSU-02','Balata Trasera Tambor Tsuru III','Juego de zapatas traseras',160.00,270.00,13.00,3.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(11,'DIS-VER-01','Disco de Freno Delantero Versa/March','Disco ventilado reforzado',350.00,580.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(12,'DIS-TSU-02','Disco de Freno Delantero Tsuru III','Disco macizo/ventilado estándar',280.00,460.00,9.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(13,'DIS-CHE-03','Disco de Freno Delantero Chevy','Disco macizo 236mm',240.00,410.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(14,'LIQ-FRE-01','Líquido de Frenos DOT 4 500ml','Alto punto de ebullición',45.00,85.00,25.00,5.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(15,'LIQ-FRE-02','Líquido de Frenos DOT 3 250ml','Uso automotriz general',28.00,55.00,30.00,5.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(16,'BAL-D21-07','Balata Delantera Nissan D21 / PickUp (1994-2008)','Semimetálica servicio pesado',190.00,320.00,9.00,3.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(17,'BAL-POI-08','Balata Delantera Pointer (1998-2010)','Cerámica estándar',160.00,280.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(18,'BAL-SPA-09','Balata Delantera Spark / Beat (2011-2022)','Cerámica ciudad',210.00,350.00,14.00,3.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(19,'BAL-HIL-10','Balata Delantera Toyota Hilux (2006-2022)','Servicio pesado 4x2/4x4',320.00,540.00,7.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(20,'BAL-JET-11','Balata Delantera Jetta A4 / Clásico (1999-2015)','Cerámica europea con sensor',280.00,480.00,11.00,3.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(21,'BAL-COR-12','Balata Delantera Corsa / Tornado (2003-2011)','Semimetálica alto agarre',180.00,310.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(22,'BAL-SWI-13','Balata Delantera Suzuki Swift (2012-2023)','Cerámica de precisión',270.00,460.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(23,'BAL-SEN-14','Balata Delantera Sentra B17 (2013-2019)','Cerámica bajo polvo',290.00,490.00,10.00,2.00,0,'2026-07-31 02:39:13.000000',1,1,'Pieza',1),(24,'FIL-ACE-01','Filtro de Aceite Tsuru / Sentra B13-B15','Filtro blindado estándar',35.00,70.00,40.00,8.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(25,'FIL-ACE-02','Filtro de Aceite Versa / March / Kicks','Filtro rosca fina OE',42.00,85.00,35.00,8.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(26,'FIL-ACE-03','Filtro de Aceite Chevy / Corsa / Tornado','Filtro m20x1.5',38.00,75.00,30.00,6.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(27,'FIL-ACE-04','Filtro de Aceite Vocho Sedan 1600 i','Filtro de aceite roscado',40.00,80.00,20.00,5.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(28,'FIL-ACE-05','Filtro de Aceite Jetta A4 2.0L / Golf','Filtro capacidad extendida',45.00,90.00,25.00,5.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(29,'FIL-AIR-01','Filtro de Aire Versa / March (2012-2019)','Panel de celulosa filtrante',60.00,120.00,18.00,4.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(30,'FIL-AIR-02','Filtro de Aire Tsuru III Inyección','Panel rectangular recubierto',45.00,95.00,22.00,5.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(31,'FIL-AIR-03','Filtro de Aire Chevy Todos','Panel cuadrado inyección',48.00,90.00,25.00,5.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(32,'FIL-AIR-04','Filtro de Aire Aveo 1.5L / 1.6L','Panel plegado alto flujo',65.00,130.00,15.00,3.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(33,'FIL-AIR-05','Filtro de Aire Rio / Accent 1.6L','Filtro sella sintético',70.00,140.00,12.00,3.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(34,'FIL-GAS-01','Filtro de Gasolina Tsuru / Sentra B13','Filtro de metal en línea',30.00,65.00,30.00,6.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(35,'FIL-GAS-02','Filtro de Gasolina Chevy C1 C2 C3','Filtro de plástico rápido',28.00,60.00,28.00,6.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(36,'FIL-CAB-01','Filtro de Cabina / Aire Acondicionado Versa','Filtro antipolen sintético',55.00,110.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(37,'FIL-CAB-02','Filtro de Cabina Aveo NG / Cavaleir','Filtro carbón activado',75.00,150.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',3,1,'Pieza',1),(38,NULL,'Aceite Multigrado 20W-50 Mineral (Granel)','Suelto por litro para motores trabajados',38.00,65.00,120.00,20.00,1,'2026-07-31 02:39:13.000000',2,1,'Litro',1),(39,NULL,'Aceite Semi-Sintético 10W-30 (Granel)','Suelto por litro flotillas y uso diario',48.00,85.00,95.00,15.00,1,'2026-07-31 02:39:13.000000',2,1,'Litro',1),(40,NULL,'Aceite 100% Sintético 5W-30 (Granel)','Suelto por litro motores recientes',65.00,110.00,80.00,15.00,1,'2026-07-31 02:39:13.000000',2,1,'Litro',1),(41,NULL,'Anticongelante Concentrado 100% (Granel)','Despachado por litro verde/rojo',30.00,55.00,150.00,30.00,1,'2026-07-31 02:39:13.000000',2,1,'Litro',1),(42,'ACE-MOT-01','Garrafón Aceite 20W-50 Mineral 4.73L','Protección para motores con alto kilometraje',310.00,480.00,12.00,3.00,0,'2026-07-31 02:39:13.000000',2,1,'Garrafón',1),(43,'ACE-MOT-02','Garrafón Aceite 5W-30 Sintético 4.73L','Ahorro de combustible y arranque en frío',450.00,690.00,10.00,2.00,0,'2026-07-31 02:39:13.000000',2,1,'Garrafón',1),(44,'ACE-MOT-03','Litro Aceite Botella 15W-40 Multigrado','Sellado de fábrica',65.00,105.00,22.00,5.00,0,'2026-07-31 02:39:13.000000',2,1,'Pieza',1),(45,'ACE-TRAN-01','Aceite Transmisión Manual 80W-90 946ml','Protección de engranes pesados',70.00,125.00,14.00,3.00,0,'2026-07-31 02:39:13.000000',2,1,'Pieza',1),(46,'ACE-TRAN-02','Fluido Transmisión Automática ATF Dexron III','Para cajas automáticas y dirección hidráulica',68.00,120.00,13.90,4.00,0,'2026-07-31 02:39:13.000000',2,1,'Pieza',1),(47,'ANT-LIS-01','Anticongelante Listo para Usar 33% 3.78L','Protección contra corrosión y ebullición',85.00,150.00,16.00,4.00,0,'2026-07-31 02:39:13.000000',2,1,'Garrafón',1),(48,'BUJ-NGK-01','Bujía Cobre NGK BKR6E-11 (Tsuru/Chevy)','Bujía estándar de cobre',22.00,45.00,100.00,20.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(49,'BUJ-NGK-02','Bujía Iridium NGK LZKAR6AP-11 (Versa/March)','Bujía de iridio larga duración',85.00,160.00,40.00,8.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(50,'BUJ-BOS-03','Bujía Platino Bosch WR7DC+ (Vocho/Golf A3)','Bujía de electrodo de platino',35.00,70.00,60.00,12.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(51,'BUJ-NGK-04','Bujía Platino NGK Aveo 1.5L / Beat 1.2L','Rendimiento constante',50.00,95.00,48.00,12.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(52,'CAB-BUJ-01','Juego Cables Bujía Tsuru III 16V','Silicón 7mm alta conducción',140.00,260.00,7.00,2.00,0,'2026-07-31 02:39:13.000000',5,1,'Juego',1),(53,'CAB-BUJ-02','Juego Cables Bujía Chevy 1.4L / 1.6L','Cable con supresión de ruidos',130.00,240.00,10.00,2.00,0,'2026-07-31 02:39:13.000000',5,1,'Juego',1),(54,'BOB-IGN-01','Bobina de Encendido Lápiz Versa / March','Bobina individual por cilindro',280.00,490.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(55,'BOB-IGN-02','Bobina de Encendido Cuadrada Chevy 4 Pines','Módulo de encendido integrado',310.00,550.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(56,'BOB-IGN-03','Bobina de Encendido Aveo / Optra 3 Pines','Pack de bobinas paquete',380.00,650.00,5.00,2.00,0,'2026-07-31 02:39:13.000000',5,1,'Pieza',1),(57,'AMO-DEL-01','Amortiguador Delantero Tsuru III (Gas)','Amortiguador refuerzo gas nitrógeno',380.00,620.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(58,'AMO-TRA-02','Amortiguador Trasero Chevy C1 C2 C3','Amortiguador hidráulico suave',290.00,480.00,10.00,2.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(59,'AMO-DEL-03','Amortiguador Delantero Versa / March (Gas)','Estructura McPherson completa',520.00,890.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(60,'AMO-DEL-04','Amortiguador Delantero Aveo 1.6L','Control de rebote mejorado',450.00,780.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(61,'ROT-DEL-01','Rótula Suspensión Delantera Tsuru III','Rótula inferior con engrasador',85.00,160.00,12.00,3.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(62,'ROT-DEL-02','Rótula Suspensión Chevy (Todos)','Rótula de perno guía',90.00,175.00,12.00,3.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(63,'TER-DIR-01','Terminal de Dirección Tsuru III Outer','Terminal exterior rosca fina',70.00,135.00,15.00,3.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(64,'TER-DIR-02','Terminal de Dirección Versa / March','Terminal bieleta exterior',95.00,180.00,10.00,2.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(65,'HOR-SUS-01','Horquilla Suspensión Delantera Versa Izq/Der','Con bujes y rótula integrada',420.00,720.00,4.00,2.00,0,'2026-07-31 02:39:13.000000',4,1,'Pieza',1),(66,'BOM-AGU-01','Bomba de Agua Tsuru III Motor GA16DE','Impulsor de metal alto flujo',220.00,390.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(67,'BOM-AGU-02','Bomba de Agua Chevy 1.4L / 1.6L','Incluye empaque tórico',190.00,340.00,8.00,2.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(68,'BOM-AGU-03','Bomba de Agua Versa / March HR16DE','Aluminio fundido calidad OE',310.00,540.00,5.00,2.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(69,'BAN-ALT-01','Banda Accesorios Serpentine 6PK1105 Versa','Caucho EPDM resistente a grietas',110.00,210.00,12.00,3.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(70,'BAN-ALT-02','Banda Alternador / Bomba Tsuru III 4PK855','Banda acanalada poli-v',65.00,130.00,15.00,3.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(71,'KIT-TIM-01','Kit de Distribución Chevy 1.6L (Banda + Polea)','Kit sincronización completo',320.00,580.00,5.00,2.00,0,'2026-07-31 02:39:13.000000',6,1,'Juego',1),(72,'TER-MOT-01','Termostato Motor Tsuru III 82°C','Apertura térmica exacta',75.00,140.00,10.00,2.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(73,'SOP-MOT-01','Soporte de Motor Frontal Tsuru III','Goma/metal aislamiento de vibración',160.00,290.00,6.00,2.00,0,'2026-07-31 02:39:13.000000',6,1,'Pieza',1),(74,'DIS-AV2-04','Disco de Freno Delantero Aveo NG (2018-2024)','Disco ventilado alto rendimiento',380.00,640.00,8.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(75,'DIS-JET-05','Disco de Freno Delantero Jetta A4 / Clásico','Disco ventilado 280mm',420.00,710.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(76,'MAZ-DEL-01','Maza de Rueda Delantera Versa / March (Sin ABS)','Maza de rueda 4 pernos',320.00,550.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(77,'MAZ-DEL-02','Maza de Rueda Delantera Tsuru III','Maza reforzada con balero',250.00,430.00,8.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(78,'BAL-MAZ-01','Balero de Rueda Delantero Chevy / Corsa','Balero doble hilera de bolas',110.00,210.00,15.00,4.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(79,'BAL-MAZ-02','Balero de Rueda Delantero Tsuru III / Sentra B13','Balero sellado reforzado',120.00,230.00,12.00,3.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(80,'CIL-RUE-01','Cilindro de Rueda Trasero Tsuru III','Cilindro de freno hidráulico',85.00,160.00,10.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(81,'CIL-RUE-02','Cilindro de Rueda Trasero Chevy','Cilindro de aluminio duradero',90.00,170.00,10.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(82,'BAL-RAN-15','Balata Delantera Ford Ranger (2013-2022)','Semimetálica carga pesada',340.00,580.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(83,'BAL-NP3-16','Balata Delantera Nissan NP300 / Frontier (2016-2023)','Cerámica para trabajo pesado',360.00,610.00,8.00,2.00,0,'2026-07-31 02:42:01.000000',1,1,'Pieza',1),(84,'FIL-AIR-06','Filtro de Aire Jetta A4 / Clásico 2.0L','Panel rígido de celulosa',75.00,145.00,11.00,3.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(85,'FIL-AIR-07','Filtro de Aire Nissan NP300 2.5L Gasolina','Filtro de aire alto polvo',85.00,165.00,10.00,3.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(86,'FIL-AIR-08','Filtro de Aire Ford Figo 1.5L (2016-2021)','Panel sella perfecto',80.00,150.00,8.00,2.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(87,'FIL-GAS-03','Filtro de Gasolina Jetta A4 / Golf A4','Filtro metálico 3.0 bar',65.00,130.00,12.00,3.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(88,'FIL-GAS-04','Filtro de Gasolina Vocho Sedan Inyección','Filtro metal rosca/presión',55.00,110.00,15.00,4.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(89,'FIL-CAB-03','Filtro de Cabina Sentra B17 / Kicks','Antipolen de alta eficiencia',70.00,135.00,9.00,2.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(90,'FIL-ACE-06','Filtro de Aceite Ford Ranger / Figo / Transit','Filtro elemento / cartucho',60.00,120.00,14.00,3.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(91,'FIL-ACE-07','Filtro de Aceite Nissan NP300 2.5L','Filtro blindado reforzado',50.00,95.00,20.00,5.00,0,'2026-07-31 02:42:01.000000',3,1,'Pieza',1),(92,'BIE-DIR-01','Bieleta / Tirante de Dirección Versa / March','Bieleta interior caja dirección',110.00,210.00,10.00,3.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(93,'BIE-DIR-02','Bieleta de Dirección Aveo 1.5L / 1.6L','Bieleta de ajuste alineación',105.00,200.00,10.00,3.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(94,'TORN-EST-01','Tornillo Estabilizador / Cacahuate Versa / March','Varilla enlace barra estabilizadora',80.00,155.00,14.00,4.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(95,'TORN-EST-02','Tornillo Estabilizador Jetta A4 / Clásico','Con bujes de poliuretano/goma',75.00,140.00,12.00,3.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(96,'BUJ-HOR-01','Juego Bujes de Horquilla Tsuru III (Grande y Chico)','Bujes de suspensión delantera',65.00,130.00,15.00,4.00,0,'2026-07-31 02:42:01.000000',4,1,'Juego',1),(97,'BUJ-HOR-02','Juego Bujes de Horquilla Chevy C1 C2 C3','Gomas de horquilla reforzadas',55.00,115.00,18.00,4.00,0,'2026-07-31 02:42:01.000000',4,1,'Juego',1),(98,'AMO-TRA-03','Amortiguador Trasero Versa / March (Gas)','Amortiguador trasero reforzado',340.00,590.00,8.00,2.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(99,'AMO-DEL-05','Amortiguador Delantero Jetta A4 / Clásico','Estructura amortiguadora gas',480.00,820.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(100,'CUB-POL-01','Cubrepolvo Lado Rueda Tsuru III / Sentra','Macheta de espiga con abrazaderas',35.00,75.00,20.00,5.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(101,'ESP-HOM-01','Espiga Lado Rueda Tsuru III (Sin ABS)','Junta homocinética exterior',260.00,450.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(102,'ESP-HOM-02','Espiga Lado Rueda Chevy (Todos)','Junta homocinética exterior 22 dientes',240.00,420.00,7.00,2.00,0,'2026-07-31 02:42:01.000000',4,1,'Pieza',1),(103,'BUJ-NGK-05','Bujía Iridium NGK DILKAR6A11 (Sentra B17/X-Trail)','Iridio punta fina larga duración',110.00,195.00,30.00,6.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(104,'BUJ-AUT-06','Bujía Cobre Autolite 63 (Chevy/Monza)','Bujía estándar encendido rápido',20.00,40.00,80.00,16.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(105,'BOB-IGN-04','Bobina de Encendido Jetta A4 2.0L / Golf A4','Bobina de 4 salidas',420.00,720.00,5.00,2.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(106,'BOB-IGN-05','Bobina de Encendido Tsuru III 16V (Interior Distribuidor)','Módulo bobina encendido',230.00,410.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(107,'MAR-ELE-01','Marcha / Motor de Arranque Tsuru III 16V','Motor de arranque directo',750.00,1250.00,3.00,1.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(108,'ALT-ELE-01','Alternador 80A Tsuru III 16V','Generador eléctrico 12V',1100.00,1850.00,2.00,1.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(109,'SEN-CKP-01','Cigüeñal / Sensor CKP Versa / March','Sensor de posición del cigüeñal',180.00,320.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(110,'SEN-OXI-01','Sensor de Oxígeno 4 Pines Chevy C1 C2 C3','Sensor de gases de escape',290.00,510.00,5.00,2.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(111,'SEN-OXI-02','Sensor de Oxígeno Banco 1 Versa / March','Sensor de mezcla aire-combustible',380.00,650.00,4.00,2.00,0,'2026-07-31 02:42:01.000000',5,1,'Pieza',1),(112,'EMB-KIT-01','Kit de Embrague / Clutch Tsuru III 1.6L (Disco+Plato+Collarín)','Kit completo de tracción',850.00,1420.00,4.00,1.00,0,'2026-07-31 02:42:01.000000',6,1,'Juego',1),(113,'EMB-KIT-02','Kit de Embrague / Clutch Chevy 1.6L','Kit completo calidad repuesto',790.00,1350.00,4.00,1.00,0,'2026-07-31 02:42:01.000000',6,1,'Juego',1),(114,'EMB-KIT-03','Kit de Embrague / Clutch Versa / March 1.6L','Kit con collarín hidráulico',1250.00,1980.00,3.00,1.00,0,'2026-07-31 02:42:01.000000',6,1,'Juego',1),(115,'EMP-CAB-01','Empaque de Cabeza Tsuru III GA16DE (Grafito)','Junta de cabeza motor',120.00,220.00,10.00,3.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(116,'EMP-CAB-02','Empaque de Cabeza Chevy 1.6L','Junta de cabeza sobremedida',110.00,200.00,10.00,3.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(117,'EMP-PUN-01','Empaque de Punterías / Punteras Tsuru III 16V','Empaque de silicón/goma',45.00,95.00,15.00,4.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(118,'EMP-PUN-02','Empaque de Punterías Chevy 1.4L / 1.6L','Junta de tapa de punterías',40.00,85.00,15.00,4.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(119,'DEP-ANT-01','Depósito de Recuperación Anticongelante Chevy','Tanque de expansión de plástico',95.00,180.00,8.00,2.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(120,'DEP-ANT-02','Depósito de Anticongelante Versa / March','Depósito con tapón incluido',130.00,240.00,6.00,2.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(121,'TAP-RAD-01','Tapón de Radiador Tsuru III 0.9 Bar','Tapón presurizado metálico',30.00,65.00,20.00,5.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(122,'MOT-VEN-01','Motoventilador Completo con Tolva Tsuru III','Ventilador eléctrico de radiador',420.00,750.00,4.00,1.00,0,'2026-07-31 02:42:01.000000',6,1,'Pieza',1),(123,'CAR-CLE-01','Limpiador de Carburador y Cuerpo de Aceleración 400ml','Spray removedor de carbón',35.00,70.00,30.00,6.00,0,'2026-07-31 02:42:01.000000',2,1,'Pieza',1),(124,'AER-AFLO-01','Aflojatodo / Lubricante Multiusos Spray 300ml','Penetrante contra corrosión',30.00,60.00,35.00,8.00,0,'2026-07-31 02:42:01.000000',2,1,'Pieza',1),(125,'SIL-ALT-01','Silicón Alta Temperatura RTV Gris / Negro 85g','Formador de juntas',25.00,55.00,40.00,10.00,0,'2026-07-31 02:42:01.000000',2,1,'Pieza',1),(126,'GRAS-CHA-01','Grasa para Chasis y Rodamientos Litiada 850g','Grasa multiusos bote',75.00,140.00,12.00,3.00,0,'2026-07-31 02:42:01.000000',2,1,'Pieza',1),(127,NULL,'Líquido Parabrisas Concentrado (Granel)','Suelto por litro con detergente',12.00,25.00,200.00,40.00,1,'2026-07-31 02:42:01.000000',2,1,'Litro',1),(128,'ACE-4T20-50','Aceite Multigrado 20W50 946ml','Protección para motores con alto kilometraje',65.00,110.00,40.00,10.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(129,'ACE-5W30-S','Aceite Sintético 5W30 946ml','Máxima eficiencia y protección para motores modernos',145.00,230.00,30.00,8.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(130,'ACE-10W40-S','Aceite Semi-Sintético 10W40 946ml','Ideal para uso diario y tráfico pesado',110.00,180.00,25.00,6.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(131,'ACE-S4T20-4L','Garrafa Aceite 20W50 4.73L','Ahorro para cambio completo de aceite',280.00,450.00,15.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(132,'ACE-S5W30-4L','Garrafa Aceite Sintético 5W30 4.73L','Formulación sintética avanzada',590.00,890.00,12.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(133,'ACE-TRAN-ATF','Aceite para Transmisión Automática ATF III 946ml','Fluido para transmisión y dirección hidráulica',75.00,125.00,20.00,5.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(134,'ANTIC-R-50','Anticongelante Listo para Usar 50/50 3.78L','Protección contra corrosión y sobrecalentamiento',85.00,145.00,18.00,5.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(135,'LIM-CARB-01','Limpiador de Carburador y Cuerpo Aceleración 400ml','Remueve grasa, goma y barniz al instante',42.00,80.00,35.00,10.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(136,'FIL-ACE-VER','Filtro de Aceite Versa / March / Sentra','Filtración de partículas finas',45.00,85.00,25.00,5.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(137,'FIL-ACE-CHE','Filtro de Aceite Chevy C1 C2 C3 / Aveo','Rosca estándar y sellado hermético',40.00,75.00,30.00,8.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(138,'FIL-ACE-TSU','Filtro de Aceite Tsuru III / D21','Equipo de calidad equivalente a OE',38.00,70.00,30.00,8.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(139,'FIL-ACE-JET','Filtro de Aceite Jetta A4 / Clásico 2.0L','Elemento filtrante de celulosa reforzada',55.00,98.00,20.00,5.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(140,'FIL-AIR-VER','Filtro de Aire Versa / March (2012-2019)','Flujo de aire óptimo para combustión',65.00,120.00,15.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(141,'FIL-AIR-CHE','Filtro de Aire Chevy 1.6L','Malla protectora de alta durabilidad',50.00,95.00,18.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(142,'FIL-AIR-TSU','Filtro de Aire Tsuru III Inyección','Ajuste perfecto al depurador',45.00,85.00,20.00,5.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(143,'FIL-AIR-JET','Filtro de Aire Jetta A4 / Clásico 2.0L','Retención de polvo superior',75.00,135.00,12.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(144,'FIL-GAS-UNI','Filtro de Gasolina Universal Metal 5/16','Protege inyectores contra impurezas',25.00,50.00,40.00,10.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(145,'FIL-GAS-TSU','Filtro de Gasolina Tsuru III / D21 Metal','Especial para líneas de inyección',35.00,65.00,25.00,5.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(146,'BUJ-NGK-CPR','Bujía Cobre NGK BKR6E-11','Encendido confiable y rápido',28.00,55.00,60.00,16.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(147,'BUJ-NGK-IRI','Bujía Iridio NGK LFR6AIX-11','Larga duración hasta 100,000 km',110.00,190.00,32.00,8.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(148,'BUJ-BOS-PLA','Bujía Platino Bosch FR7DP','Rendimiento superior y menor consumo',55.00,95.00,40.00,12.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(149,'CAB-IGN-CHE','Cables de Bujía Chevy 1.6L (Juego)','Silicona de alta resistencia térmica',140.00,260.00,10.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Juego',1),(150,'CAB-IGN-TSU','Cables de Bujía Tsuru III (Juego)','Aislamiento contra fugas de corriente',130.00,240.00,10.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Juego',1),(151,'BOB-IGN-VER','Bobina de Encendido Individual Versa / March','Módulo de encendido de alta potencia',290.00,480.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(152,'BOB-IGN-CHE','Bobina de Encendido Paquete Chevy 4 Pines','Salida de alto voltaje estable',320.00,550.00,6.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(153,'BOB-IGN-JET','Bobina de Encendido Jetta A4 2.0L 6 Pines','Bobina de 4 salidas tipo bloque',450.00,780.00,5.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(154,'AMR-DEL-VER','Amortiguador Delantero Versa / March (Gas)','Respuesta rápida y control de viraje',580.00,920.00,6.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(155,'AMR-TRA-VER','Amortiguador Trasero Versa / March (Gas)','Estabilidad y confort de marcha',420.00,690.00,6.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(156,'AMR-DEL-CHE','Amortiguador Delantero Chevy C1 C2 C3','Resistente a caminos irregulares',380.00,610.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(157,'AMR-TRA-CHE','Amortiguador Trasero Chevy C1 C2 C3','Especial para carga ligera',320.00,520.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(158,'AMR-DEL-TSU','Amortiguador Delantero Tsuru III Gas','Diseño duradero reforzado',410.00,650.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(159,'ROT-DEL-CHE','Rótula Suspensión Delantera Chevy','Acero forjado con cubrapolvo de neopreno',95.00,165.00,12.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(160,'ROT-DEL-VER','Rótula Suspensión Delantera Versa / March','Ajuste de precisión milimétrica',120.00,210.00,10.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(161,'HOR-DEL-CHE','Horquilla de Suspensión Chevy Izq/Der','Incluye bujes y rótula montada',290.00,480.00,6.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(162,'TER-DIR-TSU','Terminal de Dirección Exterior Tsuru III','Rosca limpia con grasera',75.00,135.00,14.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(163,'TER-DIR-VER','Terminal de Dirección Exterior Versa / March','Movimiento suave y libre de juego',95.00,175.00,12.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(164,'FOCO-H4-12V','Foco Halógeno H4 12V 60/55W Standard','Luz clara para alta y baja',35.00,70.00,30.00,8.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(165,'FOCO-H7-12V','Foco Halógeno H7 12V 55W PX26d','Iluminación nítida y uniforme',40.00,80.00,25.00,6.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(166,'FOCO-H11-12V','Foco Halógeno H11 12V 55W Faros Niebla','Excelente visión en clima adverso',55.00,110.00,20.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(167,'FOCO-LED-H4','Kit Focos LED H4 8000 Lumenes (Par)','Luz blanca ultra brillante 6000K',280.00,490.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Juego',1),(168,'PLU-LIM-18','Pluma Limpiaparabrisas 18 Pulgadas Standard','Goma de grafito silenciosa',45.00,90.00,20.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(169,'PLU-LIM-20','Pluma Limpiaparabrisas 20 Pulgadas Standard','Barrido limpio sin rayas',50.00,95.00,20.00,4.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(170,'PLU-LIM-22','Pluma Limpiaparabrisas 22 Pulgadas Banana Flex','Diseño aerodinámico flexible',70.00,130.00,15.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(171,'BAM-AGU-400','Aflojatodo Multiusos en Spray 400ml','Lubrica, desengrana y elimina chirridos',38.00,75.00,25.00,6.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(172,'SIL-ALT-TEM','Silicon Gris Alta Temperatura RTV 85g','Sellador para cárter, bombas y múltiples',32.00,65.00,30.00,8.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(173,'CINT-AIL-3M','Cinta de Aislar Negra Vulcanizada 18m','Resistente al calor y humedad',15.00,35.00,50.00,15.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(174,'BAND-ALT-TSU','Banda de Alternador Tsuru III 4PK825','Caucho reforzado de alta tracción',65.00,120.00,12.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(175,'BAND-ALT-CHE','Banda de Accesorios Chevy sin A/C 6PK870','Resistencia al desgaste por fricción',85.00,155.00,10.00,3.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(176,'BOM-GAS-TSU','Bomba de Gasolina Eléctrica Tsuru III Repuesto','Presión constante para inyección MPFI',240.00,420.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(177,'BOM-GAS-CHE','Bomba de Gasolina Repuesto Chevy C1 C2 C3','Incluye sedazo y conector eléctrico',230.00,395.00,8.00,2.00,0,'2026-07-31 03:05:57.000000',1,1,'Pieza',1),(178,'PEDIDO-ESPECIAL','Refacción Especial (Proveedor Externo)',NULL,0.00,0.00,999.00,0.00,0,'2026-08-04 02:51:21.869053',1,NULL,'Pieza',1);
/*!40000 ALTER TABLE `sistema_producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_producto_aplicaciones`
--

DROP TABLE IF EXISTS `sistema_producto_aplicaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_producto_aplicaciones` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `producto_id` bigint NOT NULL,
  `modeloauto_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sistema_producto_aplicac_producto_id_modeloauto_i_ace842ff_uniq` (`producto_id`,`modeloauto_id`),
  KEY `sistema_producto_apl_modeloauto_id_4d7ae5a1_fk_sistema_m` (`modeloauto_id`),
  CONSTRAINT `sistema_producto_apl_modeloauto_id_4d7ae5a1_fk_sistema_m` FOREIGN KEY (`modeloauto_id`) REFERENCES `sistema_modeloauto` (`id`),
  CONSTRAINT `sistema_producto_apl_producto_id_09076e84_fk_sistema_p` FOREIGN KEY (`producto_id`) REFERENCES `sistema_producto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_producto_aplicaciones`
--

LOCK TABLES `sistema_producto_aplicaciones` WRITE;
/*!40000 ALTER TABLE `sistema_producto_aplicaciones` DISABLE KEYS */;
INSERT INTO `sistema_producto_aplicaciones` VALUES (1,1,1),(2,3,2),(3,5,3),(4,6,7),(5,7,11),(7,8,2),(6,8,8),(9,9,18),(10,10,1),(12,19,17),(11,20,12),(13,136,3),(16,137,2),(14,137,7),(15,137,8),(18,138,1),(19,139,12),(20,141,7),(21,142,1),(22,143,12),(23,152,7),(24,156,7),(25,158,1);
/*!40000 ALTER TABLE `sistema_producto_aplicaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_proveedor`
--

DROP TABLE IF EXISTS `sistema_proveedor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_proveedor` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_proveedor`
--

LOCK TABLES `sistema_proveedor` WRITE;
/*!40000 ALTER TABLE `sistema_proveedor` DISABLE KEYS */;
INSERT INTO `sistema_proveedor` VALUES (1,'Distribuidora Gonher','5551234567','contacto@gonher.com',NULL);
/*!40000 ALTER TABLE `sistema_proveedor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_rol`
--

DROP TABLE IF EXISTS `sistema_rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_rol` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_rol`
--

LOCK TABLES `sistema_rol` WRITE;
/*!40000 ALTER TABLE `sistema_rol` DISABLE KEYS */;
INSERT INTO `sistema_rol` VALUES (1,'Administrador','Acceso total al sistema y reportes.'),(2,'Almacenista','Control de inventario, productos y proveedores.'),(3,'Vendedor','Punto de venta, cotizaciones y cobros.');
/*!40000 ALTER TABLE `sistema_rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_usuario`
--

DROP TABLE IF EXISTS `sistema_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_usuario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `telefono` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `sistema_usuario_rol_id_52bd6efd_fk_sistema_rol_id` (`rol_id`),
  CONSTRAINT `sistema_usuario_rol_id_52bd6efd_fk_sistema_rol_id` FOREIGN KEY (`rol_id`) REFERENCES `sistema_rol` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_usuario`
--

LOCK TABLES `sistema_usuario` WRITE;
/*!40000 ALTER TABLE `sistema_usuario` DISABLE KEYS */;
INSERT INTO `sistema_usuario` VALUES (1,'pbkdf2_sha256$1200000$wXBiiumvIRS7HolbDCt3i4$aM7PfFahmmmO0xUF9ZvG+sMiNCUsct0Q949D2Xtet4Q=','2026-08-24 18:55:30.433247',1,'paddys','','','rodrigomtz164@gmail.com',1,1,'2026-07-31 02:39:22.473684',NULL,NULL),(2,'pbkdf2_sha256$1200000$LQHEjhVhaEoHQ1AcDi36Hg$1hpB5dKuKHrjbFTx68bPhrX2eGCzA+0eAihJq11MkZs=','2026-08-24 18:50:55.288642',0,'dianita','diana','martinez','',0,1,'2026-08-01 02:48:57.000000',NULL,3),(3,'pbkdf2_sha256$1200000$ccURsZZ9VbCBe6yGw1R8ZI$N4YK6H1fTNB5oxscPjxJGEHkzuxqtbr2m3KqvqQI4zE=','2026-08-24 06:45:10.163275',0,'migue','miguel','salinas','',0,1,'2026-08-01 02:50:58.000000',NULL,2);
/*!40000 ALTER TABLE `sistema_usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_usuario_groups`
--

DROP TABLE IF EXISTS `sistema_usuario_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_usuario_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sistema_usuario_groups_usuario_id_group_id_d30749c2_uniq` (`usuario_id`,`group_id`),
  KEY `sistema_usuario_groups_group_id_bd1cefb1_fk_auth_group_id` (`group_id`),
  CONSTRAINT `sistema_usuario_groups_group_id_bd1cefb1_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `sistema_usuario_groups_usuario_id_18a52836_fk_sistema_usuario_id` FOREIGN KEY (`usuario_id`) REFERENCES `sistema_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_usuario_groups`
--

LOCK TABLES `sistema_usuario_groups` WRITE;
/*!40000 ALTER TABLE `sistema_usuario_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `sistema_usuario_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_usuario_user_permissions`
--

DROP TABLE IF EXISTS `sistema_usuario_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_usuario_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `usuario_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sistema_usuario_user_per_usuario_id_permission_id_42f5bd2a_uniq` (`usuario_id`,`permission_id`),
  KEY `sistema_usuario_user_permission_id_e36a8165_fk_auth_perm` (`permission_id`),
  CONSTRAINT `sistema_usuario_user_permission_id_e36a8165_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `sistema_usuario_user_usuario_id_4d8279cb_fk_sistema_u` FOREIGN KEY (`usuario_id`) REFERENCES `sistema_usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_usuario_user_permissions`
--

LOCK TABLES `sistema_usuario_user_permissions` WRITE;
/*!40000 ALTER TABLE `sistema_usuario_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sistema_usuario_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sistema_venta`
--

DROP TABLE IF EXISTS `sistema_venta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sistema_venta` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fecha_venta` datetime(6) NOT NULL,
  `descuento_aplicado` decimal(4,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `vendedor_id` bigint NOT NULL,
  `corte_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sistema_venta_vendedor_id_4205b731_fk_sistema_usuario_id` (`vendedor_id`),
  KEY `sistema_venta_corte_id_1c559d1a_fk_sistema_cortecaja_id` (`corte_id`),
  CONSTRAINT `sistema_venta_corte_id_1c559d1a_fk_sistema_cortecaja_id` FOREIGN KEY (`corte_id`) REFERENCES `sistema_cortecaja` (`id`),
  CONSTRAINT `sistema_venta_vendedor_id_4205b731_fk_sistema_usuario_id` FOREIGN KEY (`vendedor_id`) REFERENCES `sistema_usuario` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sistema_venta`
--

LOCK TABLES `sistema_venta` WRITE;
/*!40000 ALTER TABLE `sistema_venta` DISABLE KEYS */;
INSERT INTO `sistema_venta` VALUES (1,'2026-08-01 01:13:38.205453',0.00,560.00,560.00,1,1),(2,'2026-08-01 02:27:36.366757',0.05,560.00,532.00,1,1),(3,'2026-08-01 09:15:38.317033',0.05,560.00,532.00,2,1),(4,'2026-08-01 09:42:09.643367',0.08,760.00,699.20,1,1),(5,'2026-08-01 09:44:59.407615',0.00,1420.00,1420.00,1,1),(6,'2026-08-01 10:01:16.885886',0.00,660.00,660.00,1,1),(7,'2026-08-03 20:33:24.513498',0.05,840.00,798.00,1,1),(8,'2026-08-03 20:36:49.209953',0.08,1520.00,1398.40,2,1),(9,'2026-08-04 02:52:22.904757',0.05,384.00,364.80,2,1),(10,'2026-08-04 03:02:24.386453',0.02,225.00,220.50,1,1),(11,'2026-08-17 18:53:34.485726',0.08,365.00,335.80,1,1),(12,'2026-08-19 08:33:42.258132',0.00,280.00,280.00,1,1),(13,'2026-08-19 08:49:03.260842',0.00,210.00,210.00,1,1),(14,'2026-08-19 09:09:57.901789',0.00,560.00,560.00,1,1),(15,'2026-08-20 20:22:59.861217',0.00,335.00,335.00,1,2),(16,'2026-08-24 04:09:26.182266',0.12,450.00,396.00,2,2),(17,'2026-08-24 04:42:20.366653',0.12,715.00,629.20,2,2),(18,'2026-08-24 04:49:09.564036',0.00,470.00,470.00,2,2),(19,'2026-08-24 05:58:26.982080',0.05,1150.00,1092.50,2,2),(20,'2026-08-24 18:48:23.878121',0.04,585.00,561.60,1,3),(21,'2026-08-24 18:53:07.496406',0.00,492.00,492.00,2,3);
/*!40000 ALTER TABLE `sistema_venta` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-25 19:21:24
