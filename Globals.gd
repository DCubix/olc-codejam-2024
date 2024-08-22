extends Node

var itemTypes: Dictionary = {
	"BRD": preload("res://scenes/ingredients/bread.tscn"),
	"PTY": preload("res://scenes/ingredients/patty.tscn"),
	"CHS": preload("res://scenes/ingredients/cheese.tscn"),
	"LTC": preload("res://scenes/ingredients/lettuce.tscn"),
	"TMT": preload("res://scenes/ingredients/tomatos.tscn"),
	"ONS": preload("res://scenes/ingredients/onions.tscn"),
	"BCN": preload("res://scenes/ingredients/bacon.tscn"),
	"BTP": preload("res://scenes/ingredients/bread_top.tscn"),
	"BBT": preload("res://scenes/ingredients/bread_bot.tscn")
}

var reactor = preload("res://scenes/reaction.tscn")
