
# Constants and important variables
root3 = Math.sqrt(3)
paper = undefined
canonicalGreen = [43, 152, 132]
canonicalPurple = [149, 111, 168]
canonicalOrange = [240, 130, 84]
colorVariance = 30
sepDist = 3
sidelength = 90

$(document).ready ->

	paper = Snap('#art')

	v = new Vivus('logo', {type: 'delayed', duration: 800})

	T = trianglePattern([50, 475])


trianglePattern = (P1) -> 

	P2 = [P1[0] + sidelength, P1[1]]
	P3 = [P2[0] + sidelength / 2, P1[1] + sidelength * root3 / 2]
	P4 = [P1[0] + sidelength * 3, P1[1]]
	P5 = [P3[0] + sidelength * 2, P3[1]]
	P6 = [P5[0] + sidelength / 2, P5[1] + sidelength * root3 / 2]
	P7 = [P1[0] + sidelength * 6, P1[1]]

	T = [ triangleStreak(P1, canonicalGreen,  3),
		  triangleStreak(P2, canonicalPurple, 5),
		  triangleStreak(P3, canonicalPurple, 5),
		  triangleStreak(P4, canonicalPurple, 3),
		  triangleStreak(P5, canonicalOrange, 5),
		  triangleStreak(P6, canonicalOrange, 5),
		  triangleStreak(P7, canonicalGreen,  3) ]

	T = T.reduce((a, b) -> a.concat(b))

	flickerAll(T)

	return T


flickerOne = (t) -> 

	t.animate({opacity: 0.85}, 2000, mina.bounce, => t.animate({opacity: 1}, 2000, mina.bounce))

flickerAll = (T) ->

	_.map(_.shuffle(T), _.rateLimit(flickerOne, 60, true, => flickerAll(T)))


triangleStreak = (bottomLeft, color, numTriangles) -> 

	triangles = []

	for x in [0...numTriangles]
		point = [bottomLeft[0] + x * sidelength / 2 + sepDist, 
				 bottomLeft[1] - x * sidelength * root3 / 2 + sepDist]
		[one, two] = doubleTriangle(point, color)
		triangles.push(one)
		triangles.push(two)

	return _.shuffle(triangles)


# All triangles are equilateral
doubleTriangle = (S, color) ->

	W = [S[0] - sidelength / 2, S[1] - sidelength * root3 / 2]
	E = [W[0] + sidelength, W[1]]
	N = [S[0], S[1] - sidelength * root3]

	[r, g, b] = nearColor(color)
	one = paper.polygon([S..., W..., E...]).attr({fill: Snap.rgb(r,g,b), opacity: 1})

	[r, g, b] = nearColor(color)
	two = paper.polygon([N..., W..., E...]).attr({fill: Snap.rgb(r,g,b), opacity: 1})

	return [one, two]


nearColor = ([r, g, b]) ->
	rand = Math.random() - 0.5
	return [rand * colorVariance + r, rand * colorVariance + g, rand * colorVariance + b ]


# In case at some poin in the future, we also want the triangles to appear suddenly
# initialLightUP = (t) -> t.animate({opacity:1}, 8000, mina.bounce)










