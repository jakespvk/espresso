package main

import "core:fmt"
import "core:math/rand"

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
	mimic_boiler_heatup(sensor)
	sensor.temp = mimic_temperature_fluctuation(sensor.temp)

	return sensor.temp, true
}

mimic_temperature_fluctuation :: proc(temperature: f64) -> f64 {
	temperature_increasing := true
	delta := rand.float64()

	if (delta < 0.5) {
		temperature_increasing = false
	}

	return temperature_increasing ? temperature + delta : temperature - delta
}

mimic_boiler_heatup :: proc(sensor: ^Fake_Sensor) {
	sensor.temp += 0.001
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
		s.temp, ok = read_temperature(&boiler, &s)

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
