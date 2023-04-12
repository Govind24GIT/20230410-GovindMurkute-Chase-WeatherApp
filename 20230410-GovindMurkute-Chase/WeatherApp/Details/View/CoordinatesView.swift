//
//  CoordinatesView.swift
//  WeatherApp
//
//  Created by Govind Murkute on 12/04/23.
//

import SwiftUI

struct CoordinatesView: View {
    
    var latitude: String?
    var longitude: String?
    
    var body: some View {
        VStack(alignment: .center) {
            Divider()
            Text("Latitude:   " + "\(latitude ?? "--")")
            Divider()
            Text("Longitude:  " + "\(longitude ?? "--")")
            Divider()
        }
    }
}

struct CoordinatesView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatesView(latitude: "18", longitude: "45")
    }
}
