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
			return GetValue(gardenMapper, newVal, gM.Dest, dest)
		}
	}

	return 0
}
