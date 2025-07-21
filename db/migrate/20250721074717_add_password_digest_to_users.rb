# Sau khi thêm cột password_digest và sử dụng has_secure_password trong model, 
# format của giá trị được lưu vào cột password_digest không phải là mật khẩu gốc, 
# mà là một chuỗi mã hóa (hashed string) được tạo bởi BCrypt.
# Format : "$2a$12$R7pP7n0NcV6R7vE3uTf7PuZT1FHZ0RC3zSRYJuXL.NYfT8rZdJw2O" 
# $2a$: chỉ định BCrypt algorithm version (2a);  12:mức độ phức tạp


class AddPasswordDigestToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :password_digest, :string
  end
end
