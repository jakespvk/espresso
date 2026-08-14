package main

import "core:fmt"
import "core:math/rand"
import "core:time"

Fake_Sensor :: struct {
	temp: f64,
}

read_temperature :: proc(sensor: ^Fake_Sensor) -> (temperature: f64, ok: bool) {
	mimic_boiler_heatup(sensor)
	sensor.temp = mimic_temperature_fluctuation(sensor.temp)

	fmt.printf("sensor temp: %f\n", sensor.temp)

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
	s: Fake_Sensor = {
		temp = 62.5,
	}

	desired_temp: f64 = 93

	for s.temp < desired_temp {
		ok: bool
		s.temp, ok = read_temperature(&s)

		if !ok {
			break
		}

		time.sleep(time.Millisecond * 100)
	}

	fmt.printf("we made it boys\n")
}
