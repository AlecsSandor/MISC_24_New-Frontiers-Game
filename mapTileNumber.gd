extends Node


func spiral_matrix(n):
	var matrix = []
	for nr in range(n):
		matrix.append(nr * n)  # Initialize an n x n matrix with zeros

	var x = 0
	var y = 0
	var dx = 1
	var dy = 0

	for i in range(1, n * n + 1):
		matrix[y][x] = i  # Assign the current number

		# Check if the next position is out of bounds or has been visited
		if x + dx >= n or x + dx < 0 or y + dy >= n or y + dy < 0 or matrix[y + dy][x + dx] != 0:
			var temp = dx
			dx = -dy
			dy = temp  # Change direction (rotate 90 degrees)

		x += dx  # Move to the next position
		y += dy

	return matrix

func get_number_at_position(matrix, x, y):
	var n = matrix.size()
	if 0 <= x < n and 0 <= y < n:
		return matrix[y][x]
	else:
		return null  # Coordinates out of bounds

func _ready():
	var n = 4  # Change this to the desired matrix size
	var result_matrix = spiral_matrix(n)

	# Example: Get the number at position (2, 1)
	var position_x = 2
	var position_y = 1
	var number_at_position = get_number_at_position(result_matrix, position_x, position_y)

	if number_at_position != null:
		print('The number at position (', position_x, ', ', position_y, ') is: ', number_at_position)
	else:
		print('Invalid position: (', position_x, ', ', position_y, ')')
