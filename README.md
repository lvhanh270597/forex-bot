# Forex bot strategy

## Giới Thiệu
Đây là bot sẽ chạy trong năm 2021 với chiến lược giao dịch và kết quả backtest được thống kê ở dưới.
Lưu ý: Bot này được sử dụng trong năm 2021 và không thể thay đổi bởi bất cứ bot nào nữa.

## Các Chức Năng
* Tự động vào lệnh khi có tín hiệu
* Khi phân tích dữ liệu qua từng tick, thấy có tín hiệu vào lệnh: Bot sẽ tự động vào lệnh theo đúng nguyên tắc giao dịch của nó. 
* Gửi thông báo
* Khi đã vào lệnh mới thành công
* Khi thoát một lệnh thành công
* Khi thị trường đảo xu hướng dài hạn
## Chiến Lược Giao Dịch
### Tín hiệu vào lệnh
*	RSI không được quá mua hoặc quá bán
*	Giá chạm đường các MA và bật lại
*	Đường EMA20 phải nằm dưới EMA50 và EMA200
*	Nếu có pinbar xuất hiện tại chỗ chạm MA, thì x2 số lot trade
*	Nếu false signal thì lưu lại vị trí và tìm điểm vào lệnh trên đó
### Stoploss và Takeprofit 
*	Takeprofit được đặt 100 pip để đảm bảo rủi ro
*	Stoploss đặt ngay đáy nếu xác định xu hướng dài hạn là tăng (hoặc đỉnh nếu xác định xu hướng dài hạn là giảm)
*	Sử dụng trailing stoploss 
### Tín hiệu thoát lệnh
*	Không bao giờ thoát lệnh trừ khi chạm stoploss
# Kiến trúc kĩ thuật
## Các thông số Input
### THÔNG SỐ PHÂN BIỆT
*	MagicBot (Int): Số nguyên đánh dấu magic number cho các orders

### THÔNG SỐ TÍN HIỆU
*	TimeFrame (String): Timeframe chính lựa chọn để phân tích và vào lệnh
*	PriorityTrend (String): Xu hướng chính dài hạn
*	PeakOrBottom (Double): Giá trị đỉnh (hoặc đáy) của xu hướng hiện tại
*	ConsiderRSI (Bool): Cân nhắc thêm chỉ báo RSI vào tín hiệu giao dịch
*	PinbarRatio (Double): Độ đẹp của pinbar thể hiện qua tỉ lệ đuôi của nó so với phần còn lại
### THÔNG SỐ QUẢN LÝ VỐN
*	MaxOrdersOpened (Int): Tổng số lệnh tối đa được phép mở
*	DistanceOrdersPip (Int): Khoảng cách của các order cách nhau bao nhiêu pip
*	MaxPipLoss (Int): Tổng số pip cho phép lỗ trên bộ lệnh
*	VolumeDefault (Double): Volume vào lệnh mặc định
*	VolumeSmaller (Double): Volume vào lệnh nhỏ hơn
*	PipLossDefault (Int): Số pip cho một lệnh với VolumeDefault
*	PipLossSmaller (Int): Số pip cho một lệnh với VolumeSmaller 
*	PipMovingEntry (Int): Khi đạt lãi với số pip bằng với số này, Stoploss sẽ được dịch về entry.
*	PipTrailingStoploss (Int): Trailing stoploss với số pip này
### THÔNG SỐ PHỤ KHÁC
*	Token của Bot trên kênh Telegram
*	Danh sách các chatId của Telegram mà bot sẽ gửi thông báo tới

## Modules:
### Values/Variables.mqh
*	Nơi khai báo các extern input
### Signal/PriceAction.mqh:
*	Nơi lưu trữ các hàm liên quan đến các tín hiệu price action
### Signal/Normal.mqh:
*	Nơi lưu trữ các hàm liên quan đến các tín hiệu bình thường
### Charts/Normal.mqh:
*	Nơi lưu trữ các hàm để kiểm tra các nến bình thường (ví dụ: nến dài, nến ngắn hoặc là kiểm tra có nến mới không?)
### Notification/Telegram.mqh:
*	Lưu trữ các hàm liên quan đến việc gửi thông báo đến kênh telegram
### Notification/Termial.mqh:
*	Lưu trữ các hàm in thông báo lên termial
### OrderProcess/Normal.mqh:
*	Lưu trữ các hàm liên quan đến việc xử lý order (ví dụ: mở order,..)
### Capital/Normal.mqh:
* Lưu trữ các hàm liên quan đến quản lý vốn (ví dụ: dịch SL về Entry hoặc trailing stoploss…)
