// 
// Event.swift
// Volunteer Hour Tracker
// 
// Created by Jose Toledo on 06/16/2017
// Copyright © 2017 Toledo's IT Solutions. All Rights Reserved.
//

import UIKit

class Event: NSObject {
	// MARK: Properties

	var eventName : String
	var eventDate : String
	var eventDescription : String
	var timeStart : String
	var timeEnded : String
	var timeSpentHours : Double
	var timeSpentMinutes : Double

	// MARK: Initialization

	init?(eventName: String, eventDate: String, eventDescription: String, timeStart: String, timeEnded: String, timeSpentHours: Double, timeSpentMinutes: Double) {
		// None of the variables can be empty
		guard !eventName.isEmpty && !eventName.isEmpty && !eventName.isEmpty && !eventName.isEmpty && !eventName.isEmpty && !timeSpentHours.isEmpty && !timeSpentEmpty.isEmpty {
			return nil
		}
		
		// Initialize the properties. 
		self.eventName = eventName
		self.eventDate = eventDate
		self.eventDescription = eventDescription
		self.timeStart = timeStart 
		self.timeEnded = timeEnded
		self.timeSpentHours = timeSpentHours
		self.timeSpentMinutes = timeSpentMinutes
	}
}
