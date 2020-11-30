//
//  ContentView.swift
//  BetterRest
//
//  Created by User on 25/11/2020.
//

import SwiftUI

struct ContentView: View {

//MARK:-Variables
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    //Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    static var defaultWakeTime : Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
//MARK:-Body
    
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a date",
                               selection: $wakeUp,
                               displayedComponents : .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount,
                            in: 4...12,
                            step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Stepper(value: $coffeeAmount,
                            in: 1 ... 20) {
                        if coffeeAmount == 1 {
                            Text("1 Cup")
                        } else {
                            Text("\(coffeeAmount) Cup")
                        }
                    }
                }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                // our BUTTON
                Button(action: calculateBedTime) {
                    Text("Calculate")
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle) , message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
//MARK: -Functions
    
    func calculateBedTime () {
        let model = SleepCalculator()
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (component.hour ?? 0) * 60 * 60
        let minute = (component.minute ?? 0) * 60
        
        do  {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertTitle = "Your ideal bedtime is ..."
            alertMessage = formatter.string(from: sleepTime)
            
        } catch {
            // something went worng
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        showAlert = true
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
