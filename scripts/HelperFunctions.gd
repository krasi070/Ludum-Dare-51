extends Node


func merge_arrays(arrs: Array) -> Array:
	var result_arr: Array = []
	for i in range(arrs.size()):
		result_arr.append_array(arrs[i])
	return result_arr


func get_n_rand_items_from_arr(arr: Array, n: int) -> Array:
	randomize()
	var result_arr: Array = []
	if arr.size() >= n:
		var copy: Array = arr.duplicate(true)
		for i in range(n):
			arr.shuffle()
			result_arr.append(copy.pop_at(0))
	return result_arr
