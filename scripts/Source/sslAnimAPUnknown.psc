scriptname sslAnimAPUnknown extends sslBaseAnimation

function LoadAnimation()
	name = "AP UKNOWN"

	SetContent(Sexual)
	SetSFX(Squishing)

	int a1 = AddPosition(Female, 0, addCum=Vaginal)
	AddPositionStage(a1, "AP_Unknown_A1_S1")
	AddPositionStage(a1, "AP_Unknown_A1_S2")
	AddPositionStage(a1, "AP_Unknown_A1_S3")
	AddPositionStage(a1, "AP_Unknown_A1_S4")
	AddPositionStage(a1, "AP_Unknown_A1_S5")

	int a2 = AddPosition(Male, 44, rotation=180.0)
	AddPositionStage(a2, "AP_HoldLegUp_A2_S1")
	AddPositionStage(a2, "AP_HoldLegUp_A2_S2")
	AddPositionStage(a2, "AP_HoldLegUp_A2_S2")
	AddPositionStage(a2, "AP_HoldLegUp_A2_S3")
	AddPositionStage(a2, "AP_HoldLegUp_A2_S3")

	AddTag("AP")
	AddTag("Sex")
	AddTag("MF")
	AddTag("Straight")
endFunction