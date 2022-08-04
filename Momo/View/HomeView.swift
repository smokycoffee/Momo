//
//  HomeView.swift
//  Momo
//
//  Created by Tsenguun on 2/8/22.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: PaymentActivity.entity(),
        sortDescriptors: [ NSSortDescriptor(keyPath: \PaymentActivity.date, ascending: false) ])
    var paymentActivities: FetchedResults<PaymentActivity>
    
    
    var body: some View {
        VStack {
            HeaderView()
            CardView()
            TransactionsView()
            Spacer()
        }
        .background(Color(red: 242/255, green: 243/255, blue: 244/255))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
//
//        let context = PersistenceController.shared.container.viewContext
//        let testTrans = PaymentActivity(context: context)
//        testTrans.paymentID = UUID()
//        testTrans.name = "Flight ticket"
//        testTrans.amount = 200.0
//        testTrans.date = .today
//        testTrans.type = .expense

        
        return Group {
            HomeView()
            CardView().previewLayout(.sizeThatFits)
//            TransactionCellView(transaction: testTrans).previewLayout(.sizeThatFits)
        }
    }
}

// Header / Title View
struct HeaderView: View {
    
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text("Good afternoon,")
                        .font(.system(.subheadline, design: .default))
                    
                    Text("Tsenguun")
                        .font(.system(.title2))
                        .fontWeight(.semibold)
                }
                Spacer()
                
                Image(systemName: "bell")
                    .font(.title)
    //                .foregroundColor(.white)
            }
            .padding()
    }
}

// Card View
struct CardView: View {
        
    var body: some View {
        Rectangle()
            .frame(height: 200)
            .foregroundColor(Color("darkGreen"))
            .overlay {
                VStack {
                    HStack {
                        BalanceView(typeOf: "Total Balance ^", balance: 2548.00)
                        
                        Spacer()
                        
                        Text("...")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.system(size: 40))
                            .padding()
                            .offset(y: -30)
                    }
                    Spacer()
                    HStack {
                        MoneyTypeView(typeOf: "Income", balance: 1840.00, typeOfImage: SFSymbols.arrowDown)
                        Spacer()
                        MoneyTypeView(typeOf: "Expense", balance: 284.00, typeOfImage: SFSymbols.arrowUp)
                    }
                    
                }
                .padding()
            }
            .cornerRadius(20)
            .padding()
            .shadow(color: Color("darkGreen").opacity(0.5), radius: 5, x: 0, y: 8)
    }
}

// Total Balance
struct BalanceView: View {
    
    let typeOf: String
    let balance: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(typeOf)
                .font(.system(.title3))
                .fontWeight(.semibold)
            Text(NumberFormatter.currency(from: balance))
                .font(.system(.largeTitle))
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        
    }
}

// Income and Expense View
struct MoneyTypeView: View {
    
    let typeOf: String
    let balance: Double
    let typeOfImage: String
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                if typeOfImage != "" {
                    Image(systemName: typeOfImage)
                        .font(.body)
                        .padding(7)
                        .background(.gray.opacity(0.5))
                        .clipShape(Circle())

                }
                Text(typeOf)
                    .font(.system(.title3))
                    .fontWeight(.regular)
                    .opacity(0.8)
            }
            Text(NumberFormatter.currency(from: balance))
                .font(.system(.title2))
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        
    }
}

// Transactions View
struct TransactionsView: View {
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            HStack {
                Text("Transactions History")
                    .font(.system(.headline, design: .default))
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    // action to do
                } label: {
                    Text("See all")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .opacity(0.6)
                }
            }
//            List {
//
//            }
        }
        .padding(.horizontal)
    }
}

struct TransactionCellView: View {
    
    @ObservedObject var transaction: PaymentActivity
    
    var body: some View {
        HStack {
            if transaction.isFault {
                EmptyView()
            } else {
                Image(systemName: transaction.type == .income ? SFSymbols.arrowUp : SFSymbols.arrowDown)
                    .font(.title)
                    .foregroundColor(Color(transaction.type == .income ? "IncomeCard" : " ExpenseCard").opacity(0.5))
                
                VStack(alignment: .leading) {
                    Text(transaction.name)
                        .font(.system(.body, design: .default))
                    Text(transaction.date.string())
                        .font(.system(.caption, design: .default))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text((transaction.type == .income ? "+" : "-") + NumberFormatter.currency(from: transaction.amount))
                    .font(.system(.title2,design: .default))
            }
        }
        .padding(.vertical, 5)
    }
}
