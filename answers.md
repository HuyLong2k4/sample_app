Chapter 3:

I. gem config
- là một gem dùng để quản lý các thiết lập cấu hình trong ứng dụng Rails một cách sạch sẽ và có tổ chức
- Ưu điểm
+ File config có định dạng YML rất đơn giản
+ Hỗ trợ ERB
+ Hỗ trợ kế thừa
+ Cú pháp sử dụng đơn giản
- Cài đặt:
+ B1: Mở file Gemfile và thêm dòng sau vào trong phần group :default hoặc ở cuối file:

gem 'config'

+ B2: Cài đặt gem

bundle install

+ B3: Sau khi cài xong, chạy lệnh sau để tạo thư mục config/settings.yml và các file liên quan:

rails g config:install

- Sử dụng:

Sau khi generate các file thì mặc định Settings Object là Object toàn cục có thể sử dụng ở bất cứ đâu để gọi các giá trị được khai báo trong các file trên, cú pháp như sau:

Settings.my_config_entry

Trong trường hợp các giá trị khai báo lồng nhau thì cú pháp như sau:

Settings.my_section.some_entry

- reloading settings

Để reload settings ta dùng lệnh sau:

Settings.reload!


II . Tìm hiểu về I18n và I18n lazy lookup

- I18n (Internationalization) là thư viện hỗ trợ đa ngôn ngữ trong Rails.

- Lazy lookup (tra cứu lười biếng):

+ Là cách sử dụng i18n mà không cần viết đầy đủ đường dẫn (key).

+ Khi gọi t('.title') trong một view hay controller, Rails sẽ tự hiểu rằng title nằm trong scope hiện tại.

Ví dụ:
# config/locales/users.vi.yml
vi:
  users:
    show:
      title: "Trang người dùng"


+ Trong view users/show.html.erb, chỉ cần:

<h1><%= t('.title') %></h1>

III. Tấn công CSRF và XSS là gì? Làm thế nào để phòng tránh trong Rails?

- CSRF (Cross-Site Request Forgery): Là hình thức tấn công lợi dụng quyền của người dùng đang đăng nhập để thực hiện các hành vi trái phép.
  -->  Cách phòng tránh trong Rails: Rails tích hợp sẵn CSRF protection. Chỉ cần đảm bảo có protect_from_forgery with: :exception trong ApplicationController và dùng 
                        <%= csrf_meta_tags %> trong layout.
- XSS (Cross-Site Scripting): Là tấn công chèn mã JavaScript độc hại vào trình duyệt người dùng.
  -->  Cách phòng tránh trong Rails: Rails tự động escape HTML. Chỉ hiển thị nội dung tin cậy bằng raw() hoặc html_safe (nên hạn chế dùng).


Chapter 4:  

I. Phân biệt: nil?, empty?, blank?, present?

1. nil?
- Ý nghĩa: Kiểm tra một object có phải là nil (không có gì) không.

- Trả về: true nếu object là nil, ngược lại false.

- Dùng được cho: mọi object trong Ruby.

nil.nil?          # => true
"hello".nil?      # => false
[].nil?           # => false


2. empty?
- Ý nghĩa: Kiểm tra một object có rỗng không (không chứa phần tử hoặc ký tự nào).

- Trả về: true nếu rỗng, false nếu có nội dung.

- Chỉ dùng được cho: String, Array, Hash, v.v.

- Lưu ý: Gọi empty? trên nil sẽ bị lỗi.

"".empty?         # => true
"hello".empty?    # => false
[].empty?         # => true
{}.empty?         # => true
nil.empty?        # => NoMethodError


3. blank? (Chỉ có trong Rails)
- Ý nghĩa: Kiểm tra object rỗng hoặc trắng hay không.

- Trả về true nếu:

+ Là nil

+ Là chuỗi rỗng ("")

+ Là chuỗi chỉ chứa khoảng trắng (" ")

+ Là array/hash rỗng

- Ví dụ :

nil.blank?        # => true
"".blank?         # => true
"   ".blank?      # => true
[].blank?         # => true
"hello".blank?    # => false

 4. present? (Chỉ có trong Rails)
- Ngược lại với blank

- Trả về true nếu object có nội dung, không nil, không rỗng, không trắng.


- Ví dụ:

nil.present?      # => false
"".present?       # => false
"   ".present?    # => false
"hi".present?     # => true
[1, 2, 3].present?# => true


Chapter 5:

I. Vai trò của thư mục helper — khi nào nên dùng

Helpers trong Ruby on Rails (RoR) là các phương thức được sử dụng để cung cấp các chức năng hỗ trợ cho views, giúp việc xử lý và hiển thị dữ liệu trở nên dễ dàng và gọn gàng hơn. Chúng thường được sử dụng để thực hiện các tác vụ như định dạng dữ liệu, tạo các form elements, và các liên kết, mà không cần viết lại mã lệnh ở nhiều nơi trong ứng dụng.
Để sử dụng helpers trong RoR, chúng ta có thể tạo các phương thức helper trong các file helper tương ứng với controller của chúng ta. Ví dụ, nếu chúng ta có một controller tên là UsersController, chúng ta có thể tạo một file helper tên là users_helper.rb trong thư mục app/helpers. Trong file này, chúng ta định nghĩa các phương thức mà chúng ta muốn sử dụng trong views liên quan đến controller đó.
Sau khi định nghĩa xong, chúng ta có thể gọi các phương thức helper này trực tiếp trong các file view của chúng ta. Rails tự động làm cho tất cả các phương thức trong module ApplicationHelper có sẵn trong tất cả views, và các phương thức trong các helper khác sẽ chỉ có sẵn trong views tương ứng với controller mà helper đó được liên kết.
Ví dụ, nếu chúng ta có một phương thức helper để định dạng ngày tháng như sau:

module UsersHelper
  def format_date(date)
    date.strftime("%d/%m/%Y")
  end
end

Chúng ta có thể sử dụng một phương thức format_date trong view của UsersController để hiển thị ngày tháng :

<%= format_date(@user.created_at) %>