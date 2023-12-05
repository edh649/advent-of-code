package gardenmap

type GardenMapper struct {
	gardenMaps []GardenMap
}

func AppendGardenMap(gardenMapper GardenMapper, gardenMap GardenMap) GardenMapper {

	gardenMaps := gardenMapper.gardenMaps
	gardenMaps = append(gardenMaps, gardenMap)

	e := GardenMapper{gardenMaps}
	return e
}

func GetValue(gardenMapper GardenMapper, value int, source string, dest string) int {

	for _, gM := range gardenMapper.gardenMaps {
		if gM.Source == source {
			if gM.Dest == dest {
				return GetMappedValue(gM, value)
			}
			newVal := GetMappedValue(gM, value)
			// fmt.Println(source + " " + fmt.Sprint(value) + " -> " + gM.Dest + " " + fmt.Sprint(newVal))
			return GetValue(gardenMapper, newVal, gM.Dest, dest)
		}
	}

	panic("No valid map found!")
}

func GetInverseValue(gardenMapper GardenMapper, desiredValue int, source string, dest string) int {

	for _, gM := range gardenMapper.gardenMaps {
		if gM.Dest == dest {
			if gM.Source == source {
				return GetInversedMappedValue(gM, desiredValue)
			}
			newVal := GetInversedMappedValue(gM, desiredValue)
			// fmt.Println(gM.Source + " " + fmt.Sprint(newVal) + " <- " + dest + " " + fmt.Sprint(desiredValue))
			return GetInverseValue(gardenMapper, newVal, source, gM.Source)
		}
	}

	panic("No valid map found!")
}
