package main

import "core:fmt"

Fake_Sensor :: struct {
	temp: f64,
}

Fake_Boiler :: struct {
	power: f64,
}

heat :: proc(boiler: ^Fake_Boiler) {
	fmt.printf("heating\n")
	boiler.power += 1.0
}

cool :: proc(boiler: ^Fake_Boiler) {
	fmt.printf("cooling\n")
	boiler.power -= 1.0
}

read_temperature :: proc(
	boiler: ^Fake_Boiler,
	sensor: ^Fake_Sensor,
) -> (
	temperature: f64,
	ok: bool,
) {
	if sensor.temp > 110 {
		return 0.0, false
	} else {
		return sensor.temp, true
	}
}

main :: proc() {
	boiler: Fake_Boiler = {
		power = 50.0,
	}

	s: Fake_Sensor = {
		temp = 62.5,
	}

	desired_temp: f64 = 93

	for {
		ok: bool
		s.temp, ok = read_temperature(&s)

		if !ok {
			break
		}

		if s.temp < desired_temp {
			heat(&boiler)
		} else if s.temp > desired_temp {
			cool(&boiler)
		}
	}
}
