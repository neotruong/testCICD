import SwiftUI

struct PageControl: View {
    @Binding var currentPage: Int
    var numberOfPages: Int
    let theme = ThemeManager.shared.color
    var body: some View {
        HStack(spacing: 8) {
            // Determine the range of pages to display
            let displayPages = calculateDisplayPages()

            ForEach(displayPages, id: \.self) { index in
                Capsule()
                    .fill(capsuleColor(for: index))
                    .frame(width: capsuleWidth(for: index),
                                              height: capsuleHeight(for: index))
                    .animation(.spring(), value: currentPage)
                    .onTapGesture {
                        currentPage = index
                    }
            }
        }
        .animation(.spring(), value: currentPage)
    }
    private func calculateDisplayPages() -> [Int] {
        let maxVisiblePages = 3 
        let halfVisiblePages = maxVisiblePages / 2
        
        if numberOfPages <= maxVisiblePages {
            return Array(0..<numberOfPages)
        } else if currentPage <= halfVisiblePages {
            return Array(0..<maxVisiblePages)
        } else if currentPage >= numberOfPages - halfVisiblePages {
            return Array((numberOfPages - maxVisiblePages)..<numberOfPages)
        } else {
            return Array((currentPage - halfVisiblePages)...(currentPage + halfVisiblePages))
        }
    }

       private func capsuleColor(for index: Int) -> Color {
           return index == currentPage ? theme.primaryWhite : theme.pageControlSecondaryWhite
       }

       private func capsuleWidth(for index: Int) -> CGFloat {
           if index == currentPage {
               return 16
           } else if index == calculateDisplayPages().first || index == calculateDisplayPages().last {
               return 6
           } else {
               return 8
           }
       }

       private func capsuleHeight(for index: Int) -> CGFloat {
           return (index == calculateDisplayPages().first || index == calculateDisplayPages().last) ? 6 : 8
       }

}

#Preview {
    PageControl(currentPage: .constant(0), numberOfPages: 5)
}
