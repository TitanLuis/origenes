-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-05-2025 a las 08:07:03
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `dbtest1`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `actualizar_dias_sin_dialisis` ()   BEGIN
    -- Actualizar días sin diálisis para todos los pacientes
    UPDATE pacientes p
    LEFT JOIN (
        SELECT id_paciente, MAX(fecha) AS ultima_fecha
        FROM sesiones_hemodialisis
        GROUP BY id_paciente
    ) sd ON p.id_paciente = sd.id_paciente
    SET p.ultima_dialisis = sd.ultima_fecha;
    
    -- Actualizar prioridad para hospitalizados
    UPDATE hospitalizaciones h
    JOIN pacientes p ON h.id_paciente = p.id_paciente
    SET h.prioridad = 
        CASE 
            WHEN p.dias_sin_dialisis > 5 THEN 'URGENTE'
            WHEN p.dias_sin_dialisis > 3 THEN 'ALTA'
            WHEN p.dias_sin_dialisis > 1 THEN 'MEDIA'
            ELSE 'BAJA'
        END
    WHERE h.fecha_alta IS NULL;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargousuario`
--

CREATE TABLE `cargousuario` (
  `id_cargo` int(2) NOT NULL,
  `cargo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cargousuario`
--

INSERT INTO `cargousuario` (`id_cargo`, `cargo`) VALUES
(1, 'Médico'),
(2, 'Enfermero'),
(3, 'Nutricionista'),
(4, 'Psicólogo'),
(5, 'Asistente social'),
(6, 'Tec. Enfermería'),
(7, 'Tec. Mantenimiento');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `examenes_laboratorio`
--

CREATE TABLE `examenes_laboratorio` (
  `id_examen` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hemoglobina` decimal(4,1) DEFAULT NULL,
  `hematocrito` decimal(4,1) DEFAULT NULL,
  `ferritina` int(11) DEFAULT NULL,
  `transferrina` int(11) DEFAULT NULL,
  `sat_transferrina` decimal(4,1) DEFAULT NULL,
  `urea_pre` int(11) DEFAULT NULL,
  `urea_post` int(11) DEFAULT NULL,
  `creatinina` decimal(5,2) DEFAULT NULL,
  `ktv` decimal(3,2) DEFAULT NULL,
  `calcio` decimal(4,2) DEFAULT NULL,
  `fosforo` decimal(4,2) DEFAULT NULL,
  `pth` int(11) DEFAULT NULL,
  `albumina` decimal(3,1) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historias_clinicas`
--

CREATE TABLE `historias_clinicas` (
  `id_historia` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `diagnostico_principal` varchar(100) DEFAULT NULL,
  `etapa_erc` varchar(10) DEFAULT NULL,
  `comorbilidades` text DEFAULT NULL,
  `alergias` text DEFAULT NULL,
  `medicamentos_habituales` text DEFAULT NULL,
  `tipo_acceso_vascular` enum('FAV','CVC-T','CVC-LP','OTRO') DEFAULT NULL,
  `fecha_acceso_vascular` date DEFAULT NULL,
  `peso_seco` decimal(5,2) DEFAULT NULL,
  `talla` decimal(5,2) DEFAULT NULL,
  `ultima_actualizacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hospitalizaciones`
--

CREATE TABLE `hospitalizaciones` (
  `id_hospitalizacion` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `fecha_ingreso` date NOT NULL,
  `fecha_alta` date DEFAULT NULL,
  `servicio` varchar(50) DEFAULT NULL,
  `area` varchar(50) DEFAULT NULL,
  `cama` varchar(20) DEFAULT NULL,
  `diagnostico_hospitalario` text DEFAULT NULL,
  `prioridad` enum('URGENTE','ALTA','MEDIA','BAJA') DEFAULT 'MEDIA',
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs`
--

CREATE TABLE `logs` (
  `id_log` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `accion` varchar(255) NOT NULL,
  `tabla_afectada` varchar(50) DEFAULT NULL,
  `registro_id` int(11) DEFAULT NULL,
  `valores_antes` text DEFAULT NULL,
  `valores_despues` text DEFAULT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `ip_origen` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `logs`
--

INSERT INTO `logs` (`id_log`, `usuario_id`, `accion`, `tabla_afectada`, `registro_id`, `valores_antes`, `valores_despues`, `fecha_registro`, `ip_origen`) VALUES
(1, 1, 'Actualización de usuario ID 2', 'usuarios', 2, NULL, '{\"id_usuario\":2,\"n_doc_us\":\"456789\",\"nombres\":\"Lucia Fernanda\",\"ap_paterno\":\"Rodr\\u00edguez\",\"ap_materno\":\"Saira\",\"sexo_us\":2,\"f_nac\":\"1998-05-10\",\"cargo\":4,\"n_colegiatura\":25290,\"n_especialidad\":1586,\"telf_us\":\"958660660\",\"correo\":\"lucia@correo.con\",\"tipo_us\":3,\"password\":\"$2y$10$Fr03nMsThlJIIBZ1tBFXB.nOjUwHmf9NuK78ZwFFEESeVAv\\/jVjm.\",\"f_registro\":\"2025-04-30 01:22:46\",\"f_actualizacion\":\"2025-04-30 21:40:31\"}', '2025-04-30 21:40:31', '::1'),
(2, 1, 'Actualización de usuario ID 2', 'usuarios', 2, NULL, '{\"id_usuario\":2,\"n_doc_us\":\"456789\",\"nombres\":\"Lucia Fernanda\",\"ap_paterno\":\"Rodr\\u00edguez\",\"ap_materno\":\"Saira\",\"sexo_us\":2,\"f_nac\":\"1998-05-10\",\"cargo\":4,\"n_colegiatura\":25290,\"n_especialidad\":1586,\"telf_us\":\"958660660\",\"correo\":\"lucia@correo.con\",\"tipo_us\":2,\"password\":\"$2y$10$Fr03nMsThlJIIBZ1tBFXB.nOjUwHmf9NuK78ZwFFEESeVAv\\/jVjm.\",\"f_registro\":\"2025-04-30 01:22:46\",\"f_actualizacion\":\"2025-04-30 21:42:10\"}', '2025-04-30 21:42:10', '::1'),
(3, 1, 'Actualización de usuario ID 4', 'usuarios', 4, NULL, '{\"id_usuario\":4,\"n_doc_us\":\"456123\",\"nombres\":\"Roberto\",\"ap_paterno\":\"Luna\",\"ap_materno\":\"Victoria\",\"sexo_us\":1,\"f_nac\":\"1998-02-01\",\"cargo\":6,\"n_colegiatura\":null,\"n_especialidad\":null,\"telf_us\":\"989700555\",\"correo\":\"roberto@correo.com\",\"tipo_us\":3,\"password\":\"$2y$10$WY6GlFhSni4uW6ukf4b6BuG6cEhsy8lZBqlC3W4dW7lte0qcnkkJ.\",\"f_registro\":\"2025-04-30 23:37:24\",\"f_actualizacion\":\"2025-04-30 23:40:04\"}', '2025-04-30 23:40:04', '::1'),
(4, 1, 'Eliminación de usuario ID 4', 'usuarios', 4, '{\"id_usuario\":4,\"n_doc_us\":\"456123\",\"nombres\":\"Roberto\",\"ap_paterno\":\"Luna\",\"ap_materno\":\"Victoria\",\"sexo_us\":1,\"f_nac\":\"1998-02-01\",\"cargo\":6,\"n_colegiatura\":null,\"n_especialidad\":null,\"telf_us\":\"989700555\",\"correo\":\"roberto@correo.com\",\"tipo_us\":3,\"password\":\"$2y$10$WY6GlFhSni4uW6ukf4b6BuG6cEhsy8lZBqlC3W4dW7lte0qcnkkJ.\",\"f_registro\":\"2025-04-30 23:37:24\",\"f_actualizacion\":\"2025-04-30 23:40:04\"}', NULL, '2025-04-30 23:40:43', '::1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pacientes`
--

CREATE TABLE `pacientes` (
  `id_paciente` int(11) NOT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `ap_paterno` varchar(40) NOT NULL,
  `ap_materno` varchar(40) DEFAULT NULL,
  `nombres` varchar(60) NOT NULL,
  `sexo` enum('MASCULINO','FEMENINO') DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `direccion` varchar(100) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `contacto_emergencia` varchar(100) DEFAULT NULL,
  `telefono_emergencia` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `estado_civil` varchar(20) DEFAULT NULL,
  `religion` varchar(20) DEFAULT NULL,
  `ocupacion` varchar(30) DEFAULT NULL,
  `grado_instruccion` varchar(30) DEFAULT NULL,
  `grupo_sanguineo` varchar(10) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` datetime DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','FALLECIDO','TRASLADADO') NOT NULL DEFAULT 'ACTIVO',
  `acreditado` enum('SI','NO') DEFAULT 'NO',
  `fecha_acreditacion` date DEFAULT NULL,
  `ultima_dialisis` date DEFAULT NULL,
  `dias_sin_dialisis` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `pacientes`
--
DELIMITER $$
CREATE TRIGGER `actualizar_dias_sin_dialisis` BEFORE INSERT ON `pacientes` FOR EACH ROW BEGIN
    IF NEW.ultima_dialisis IS NOT NULL THEN
        SET NEW.dias_sin_dialisis = DATEDIFF(CURRENT_DATE, NEW.ultima_dialisis);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_dias_sin_dialisis_update` BEFORE UPDATE ON `pacientes` FOR EACH ROW BEGIN
    IF NEW.ultima_dialisis IS NOT NULL AND (OLD.ultima_dialisis IS NULL OR NEW.ultima_dialisis <> OLD.ultima_dialisis) THEN
        SET NEW.dias_sin_dialisis = DATEDIFF(CURRENT_DATE, NEW.ultima_dialisis);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serologias`
--

CREATE TABLE `serologias` (
  `id_serologia` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hbsag` enum('POSITIVO','NEGATIVO','PENDIENTE') DEFAULT NULL,
  `anti_hbs` enum('POSITIVO','NEGATIVO','PENDIENTE') DEFAULT NULL,
  `anti_hbc` enum('POSITIVO','NEGATIVO','PENDIENTE') DEFAULT NULL,
  `hcv` enum('POSITIVO','NEGATIVO','PENDIENTE') DEFAULT NULL,
  `hiv` enum('POSITIVO','NEGATIVO','PENDIENTE') DEFAULT NULL,
  `vdrl` enum('POSITIVO','NEGATIVO','PENDIENTE') DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_hemodialisis`
--

CREATE TABLE `sesiones_hemodialisis` (
  `id_sesion` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `turno` enum('I','II','III','IV') NOT NULL,
  `maquina` varchar(20) NOT NULL,
  `sala` int(11) NOT NULL,
  `peso_inicial` decimal(5,2) DEFAULT NULL,
  `peso_final` decimal(5,2) DEFAULT NULL,
  `ultrafiltracion` int(11) DEFAULT NULL,
  `tiempo_hemodialisis` time DEFAULT NULL,
  `qb` int(11) DEFAULT NULL,
  `qd` int(11) DEFAULT NULL,
  `heparina` int(11) DEFAULT NULL,
  `filtro` varchar(50) DEFAULT NULL,
  `area_filtro` decimal(3,1) DEFAULT NULL,
  `presion_arterial` varchar(20) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `enfermero_inicio` varchar(100) DEFAULT NULL,
  `enfermero_final` varchar(100) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `sesiones_hemodialisis`
--
DELIMITER $$
CREATE TRIGGER `after_sesion_insert` AFTER INSERT ON `sesiones_hemodialisis` FOR EACH ROW BEGIN
    -- Actualizar última diálisis cuando se registra una nueva sesión
    UPDATE pacientes 
    SET ultima_dialisis = NEW.fecha
    WHERE id_paciente = NEW.id_paciente;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sexo`
--

CREATE TABLE `sexo` (
  `id_sexo` int(11) NOT NULL,
  `sexo` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sexo`
--

INSERT INTO `sexo` (`id_sexo`, `sexo`) VALUES
(1, 'Masculino'),
(2, 'Femenino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipousuario`
--

CREATE TABLE `tipousuario` (
  `id_tipo_us` int(2) NOT NULL,
  `tipo_us` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipousuario`
--

INSERT INTO `tipousuario` (`id_tipo_us`, `tipo_us`) VALUES
(1, 'SuperAdministrador'),
(2, 'Administrador'),
(3, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transfusiones`
--

CREATE TABLE `transfusiones` (
  `id_transfusion` int(11) NOT NULL,
  `id_paciente` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `componente` enum('GR','PL','CRIO','PLAQ') NOT NULL,
  `cantidad` int(11) NOT NULL,
  `numero_bolsa` varchar(50) DEFAULT NULL,
  `indicacion` text DEFAULT NULL,
  `reaccion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tratamientos_sesion`
--

CREATE TABLE `tratamientos_sesion` (
  `id_tratamiento` int(11) NOT NULL,
  `id_sesion` int(11) NOT NULL,
  `tipo_tratamiento` enum('EPO','HIERRO','B12','CALCITRIOL','OTRO') NOT NULL,
  `dosis` decimal(10,2) NOT NULL,
  `unidad_medida` varchar(20) NOT NULL,
  `via_administracion` varchar(20) DEFAULT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `n_doc_us` varchar(15) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `ap_paterno` varchar(50) NOT NULL,
  `ap_materno` varchar(50) NOT NULL,
  `sexo_us` int(1) DEFAULT NULL,
  `f_nac` date DEFAULT NULL,
  `cargo` int(2) DEFAULT NULL,
  `n_colegiatura` int(11) DEFAULT NULL,
  `n_especialidad` int(11) DEFAULT NULL,
  `telf_us` varchar(20) DEFAULT NULL,
  `correo` varchar(50) DEFAULT NULL,
  `tipo_us` int(2) NOT NULL,
  `password` varchar(255) NOT NULL,
  `f_registro` datetime NOT NULL DEFAULT current_timestamp(),
  `f_actualizacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `n_doc_us`, `nombres`, `ap_paterno`, `ap_materno`, `sexo_us`, `f_nac`, `cargo`, `n_colegiatura`, `n_especialidad`, `telf_us`, `correo`, `tipo_us`, `password`, `f_registro`, `f_actualizacion`) VALUES
(1, '123456', 'Pablo', 'Salas', 'Paredes', 1, '1990-04-15', 1, 12134, 1234, '900800700', 'pablo@correo.com', 1, '$2y$10$FetE99xdDLNBKy5EYpjCL..0R2ThAMCjPAHMqGrxflXLER6VnDE46', '2025-04-27 03:49:10', '2025-04-27 10:47:31'),
(2, '456789', 'Lucia Fernanda', 'Rodríguez', 'Saira', 2, '1998-05-10', 4, 25290, 1586, '958660660', 'lucia@correo.con', 2, '$2y$10$Fr03nMsThlJIIBZ1tBFXB.nOjUwHmf9NuK78ZwFFEESeVAv/jVjm.', '2025-04-30 01:22:46', '2025-04-30 21:42:10'),
(3, '789456', 'Diana', 'Solis', 'Ramos', 2, '2000-05-12', 3, 12252, NULL, '989500123', 'diana@correo.com', 3, '$2y$10$ciXEClmCuEA1ErPJ20EZXOECuQU5/mFmo8/blblrcYcC0/baibbZq', '2025-04-30 11:30:17', '2025-04-30 11:30:17'),
(5, '456123', 'Carolina', 'Herrera', 'Farge', 2, '2001-12-05', 6, NULL, NULL, '988122535', 'carolina@correo.com', 3, '$2y$10$opcidNVUR6kxN/JIZhHy2.drk0V8RA4XhSVodZ1Nb.bULxydJXYBy', '2025-04-30 23:42:39', '2025-04-30 23:42:39');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_pacientes_hospitalizados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_pacientes_hospitalizados` (
`id_paciente` int(11)
,`nombre_completo` varchar(142)
,`dni` varchar(20)
,`servicio` varchar(50)
,`area` varchar(50)
,`cama` varchar(20)
,`ultima_dialisis` date
,`dias_sin_dialisis` int(11)
,`prioridad` enum('URGENTE','ALTA','MEDIA','BAJA')
,`diagnostico_hospitalario` text
,`fecha_ingreso` date
,`dias_hospitalizado` int(7)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_pacientes_no_acreditados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_pacientes_no_acreditados` (
`id_paciente` int(11)
,`nombre_completo` varchar(142)
,`dni` varchar(20)
,`ultima_dialisis` date
,`dias_sin_dialisis` int(11)
,`prioridad` varchar(7)
,`fecha_registro` datetime
);

-- --------------------------------------------------------

--
-- Estructura para la vista `v_pacientes_hospitalizados`
--
DROP TABLE IF EXISTS `v_pacientes_hospitalizados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_pacientes_hospitalizados`  AS SELECT `p`.`id_paciente` AS `id_paciente`, concat(`p`.`ap_paterno`,' ',`p`.`ap_materno`,' ',`p`.`nombres`) AS `nombre_completo`, `p`.`dni` AS `dni`, `h`.`servicio` AS `servicio`, `h`.`area` AS `area`, `h`.`cama` AS `cama`, `p`.`ultima_dialisis` AS `ultima_dialisis`, `p`.`dias_sin_dialisis` AS `dias_sin_dialisis`, `h`.`prioridad` AS `prioridad`, `h`.`diagnostico_hospitalario` AS `diagnostico_hospitalario`, `h`.`fecha_ingreso` AS `fecha_ingreso`, to_days(curdate()) - to_days(`h`.`fecha_ingreso`) AS `dias_hospitalizado` FROM (`pacientes` `p` join `hospitalizaciones` `h` on(`p`.`id_paciente` = `h`.`id_paciente`)) WHERE `h`.`fecha_alta` is null ORDER BY `h`.`prioridad` DESC, `p`.`dias_sin_dialisis` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_pacientes_no_acreditados`
--
DROP TABLE IF EXISTS `v_pacientes_no_acreditados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_pacientes_no_acreditados`  AS SELECT `p`.`id_paciente` AS `id_paciente`, concat(`p`.`ap_paterno`,' ',`p`.`ap_materno`,' ',`p`.`nombres`) AS `nombre_completo`, `p`.`dni` AS `dni`, `p`.`ultima_dialisis` AS `ultima_dialisis`, `p`.`dias_sin_dialisis` AS `dias_sin_dialisis`, CASE WHEN `p`.`dias_sin_dialisis` > 5 THEN 'URGENTE' WHEN `p`.`dias_sin_dialisis` > 3 THEN 'ALTA' WHEN `p`.`dias_sin_dialisis` > 1 THEN 'MEDIA' ELSE 'BAJA' END AS `prioridad`, `p`.`fecha_registro` AS `fecha_registro` FROM `pacientes` AS `p` WHERE `p`.`acreditado` = 'NO' AND !(`p`.`id_paciente` in (select `hospitalizaciones`.`id_paciente` from `hospitalizaciones` where `hospitalizaciones`.`fecha_alta` is null)) ORDER BY `p`.`dias_sin_dialisis` DESC ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cargousuario`
--
ALTER TABLE `cargousuario`
  ADD PRIMARY KEY (`id_cargo`);

--
-- Indices de la tabla `examenes_laboratorio`
--
ALTER TABLE `examenes_laboratorio`
  ADD PRIMARY KEY (`id_examen`),
  ADD KEY `id_paciente` (`id_paciente`);

--
-- Indices de la tabla `historias_clinicas`
--
ALTER TABLE `historias_clinicas`
  ADD PRIMARY KEY (`id_historia`),
  ADD KEY `id_paciente` (`id_paciente`);

--
-- Indices de la tabla `hospitalizaciones`
--
ALTER TABLE `hospitalizaciones`
  ADD PRIMARY KEY (`id_hospitalizacion`),
  ADD KEY `idx_hospitalizado` (`id_paciente`,`fecha_alta`);

--
-- Indices de la tabla `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indices de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  ADD PRIMARY KEY (`id_paciente`),
  ADD UNIQUE KEY `dni` (`dni`);

--
-- Indices de la tabla `serologias`
--
ALTER TABLE `serologias`
  ADD PRIMARY KEY (`id_serologia`),
  ADD KEY `id_paciente` (`id_paciente`);

--
-- Indices de la tabla `sesiones_hemodialisis`
--
ALTER TABLE `sesiones_hemodialisis`
  ADD PRIMARY KEY (`id_sesion`),
  ADD KEY `id_paciente` (`id_paciente`);

--
-- Indices de la tabla `sexo`
--
ALTER TABLE `sexo`
  ADD PRIMARY KEY (`id_sexo`);

--
-- Indices de la tabla `tipousuario`
--
ALTER TABLE `tipousuario`
  ADD PRIMARY KEY (`id_tipo_us`);

--
-- Indices de la tabla `transfusiones`
--
ALTER TABLE `transfusiones`
  ADD PRIMARY KEY (`id_transfusion`),
  ADD KEY `id_paciente` (`id_paciente`);

--
-- Indices de la tabla `tratamientos_sesion`
--
ALTER TABLE `tratamientos_sesion`
  ADD PRIMARY KEY (`id_tratamiento`),
  ADD KEY `id_sesion` (`id_sesion`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `sexo_us` (`sexo_us`,`tipo_us`),
  ADD KEY `tipo_us` (`tipo_us`),
  ADD KEY `cargo` (`cargo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cargousuario`
--
ALTER TABLE `cargousuario`
  MODIFY `id_cargo` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `examenes_laboratorio`
--
ALTER TABLE `examenes_laboratorio`
  MODIFY `id_examen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historias_clinicas`
--
ALTER TABLE `historias_clinicas`
  MODIFY `id_historia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `hospitalizaciones`
--
ALTER TABLE `hospitalizaciones`
  MODIFY `id_hospitalizacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `logs`
--
ALTER TABLE `logs`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `pacientes`
--
ALTER TABLE `pacientes`
  MODIFY `id_paciente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `serologias`
--
ALTER TABLE `serologias`
  MODIFY `id_serologia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sesiones_hemodialisis`
--
ALTER TABLE `sesiones_hemodialisis`
  MODIFY `id_sesion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sexo`
--
ALTER TABLE `sexo`
  MODIFY `id_sexo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `tipousuario`
--
ALTER TABLE `tipousuario`
  MODIFY `id_tipo_us` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `transfusiones`
--
ALTER TABLE `transfusiones`
  MODIFY `id_transfusion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tratamientos_sesion`
--
ALTER TABLE `tratamientos_sesion`
  MODIFY `id_tratamiento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `examenes_laboratorio`
--
ALTER TABLE `examenes_laboratorio`
  ADD CONSTRAINT `examenes_laboratorio_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `historias_clinicas`
--
ALTER TABLE `historias_clinicas`
  ADD CONSTRAINT `historias_clinicas_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `hospitalizaciones`
--
ALTER TABLE `hospitalizaciones`
  ADD CONSTRAINT `fk_hosp_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `serologias`
--
ALTER TABLE `serologias`
  ADD CONSTRAINT `serologias_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sesiones_hemodialisis`
--
ALTER TABLE `sesiones_hemodialisis`
  ADD CONSTRAINT `sesiones_hemodialisis_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `transfusiones`
--
ALTER TABLE `transfusiones`
  ADD CONSTRAINT `transfusiones_ibfk_1` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE CASCADE;

--
-- Filtros para la tabla `tratamientos_sesion`
--
ALTER TABLE `tratamientos_sesion`
  ADD CONSTRAINT `tratamientos_sesion_ibfk_1` FOREIGN KEY (`id_sesion`) REFERENCES `sesiones_hemodialisis` (`id_sesion`) ON DELETE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`tipo_us`) REFERENCES `tipousuario` (`id_tipo_us`),
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`sexo_us`) REFERENCES `sexo` (`id_sexo`),
  ADD CONSTRAINT `usuarios_ibfk_3` FOREIGN KEY (`cargo`) REFERENCES `cargousuario` (`id_cargo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
