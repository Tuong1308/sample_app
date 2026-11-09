# Chapter 3 – Mostly Static Pages

> **Thực tập sinh:** Đỗ Tấn Tường
> **Ngày học:** 09/11/2026
> **Tài liệu:** Ruby on Rails Tutorial (Michael Hartl) – Chapter 3
> **Nhánh:** `chapter_3_MostlyStaticPages`

---

## 1. Tổng quan

Chapter 3 xây dựng `sample_app` với các trang tĩnh (Home, Help, About, Contact), đồng thời làm quen với **test tự động** và chu trình **Red → Green → Refactor**.

| Mục | Nội dung |
|---|---|
| 3.1 | Set up project `sample_app`, thêm README, push lên GitHub, deploy |
| 3.2 | Tạo `StaticPagesController` bằng `rails generate`, viết HTML cho Home và Help |
| 3.3 | Bắt đầu với test, thêm trang About theo TDD |
| 3.4 | Title động bằng `provide`/`yield`, layout, đặt root route |
| 3.6 | (Tùy chọn) minitest reporters và Guard |

---

## 2. Môi trường phát triển

| Thành phần | Phiên bản / Công cụ |
|---|---|
| Hệ điều hành | Windows + **WSL (Ubuntu)** |
| Editor | VS Code (extension WSL) |
| Ruby | **4.0.9** |
| Rails | **8.1.4.1** |

---

## 3. Các bước đã thực hiện

### 3.1. Set up project
- Tạo `sample_app`, thêm README, commit và push lên GitHub.
- Bài tập 1: kiểm tra README đã hiển thị trên GitHub. ✅
- Bài tập 2: kiểm tra deploy. ✅

![Ảnh 3.1](<link ảnh>)

### 3.2. Static Pages controller

```bash
rails generate controller StaticPages home help
```

Rails tự tạo: controller, 2 route (`get 'static_pages/home'`, `get 'static_pages/help'`), thư mục view cùng `home.html.erb` và `help.html.erb`, file test, helper và file SCSS. Action `about` được **cố ý bỏ** để tự thêm ở 3.3.

Luồng xử lý: `Browser → routes.rb → StaticPagesController#home → home.html.erb`.

**Bài tập:**

| # | Yêu cầu | Trạng thái |
|---|---|---|
| 1 | Tạo controller `Foo` với 2 action `bar`, `baz` | ✅ |
| 2 | Xóa controller và 2 action vừa tạo (`rails destroy`) | ✅ |

![Ảnh 3.2](<link ảnh>)

### 3.3. Thêm trang About theo TDD

Vòng lặp: **đọc lỗi → sửa đúng chỗ lỗi chỉ ra → chạy lại**.

| Bước | Lỗi khi chạy `rails test` | Cách sửa |
|---|---|---|
| Red | `undefined local variable or method 'static_pages_about_url'` | Thêm `get 'static_pages/about'` vào `routes.rb` |
| Red | `ActionNotFound: The action 'about' could not be found` | Thêm `def about; end` vào controller |
| Red | `missing a template for this request format` | `touch app/views/static_pages/about.html.erb` và điền nội dung |
| **Green** | `3 tests, 3 assertions, 0 failures` | Hoàn thành |

![Ảnh 3.3](<link ảnh>)

### 3.4. Trang có title động

**Red:** thêm `assert_select "title", "<Tên trang> | Ruby on Rails Tutorial Sample App"` vào test của từng trang. Kết quả `3 tests, 6 assertions, 3 failures`.

**Green:** viết đầy đủ khung HTML và `<title>` cho từng view, test pass.

**Refactor:**
1. Ba view đều dùng `<% provide(:title, "...") %>` và `<title><%= yield(:title) %> | Ruby on Rails Tutorial Sample App</title>`.
2. Bật lại layout: `mv layout_file app/views/layouts/application.html.erb`, sửa dòng `<title>` trong layout.
3. Xóa phần khung HTML thừa trong 3 view, chỉ giữ `provide` và nội dung riêng.
4. `rails test` vẫn green.

**Bài tập:**

| # | Yêu cầu | Trạng thái |
|---|---|---|
| 1 | Gom `base_title` bằng `setup` và `@base_title` | ✅ |
| 2 | Tạo trang Contact theo chu trình Red → Green | ✅ |

![Ảnh 3.4](<link ảnh>)

### 3.4.4. Root route

Đổi `root 'application#hello'` thành `root 'static_pages#home'`.

| # | Yêu cầu | Trạng thái |
|---|---|---|
| 1 | Viết test `get root_url` + `assert_response :success` | ✅ |
| 2 | Comment root route → test **đỏ**, bỏ comment → test **xanh** | ✅ |

![Ảnh root route](<link ảnh>)

### 3.6. Advanced testing setup (tùy chọn)
- 3.6.1 minitest reporters: thêm `require "minitest/reporters"` và `Minitest::Reporters.use!` vào `test/test_helper.rb`, kết quả test hiển thị màu đỏ/xanh rõ ràng. ✅
- 3.6.2 Guard: `bundle exec guard init`, cấu hình `Guardfile`, chạy `bundle exec guard` để tự chạy test khi lưu file. ✅

![Ảnh 3.6](<link ảnh>)

---

## 4. Kiến thức rút ra

### 4.1. Controller, action, view và route
- **Controller** là một class Ruby kế thừa `ApplicationController` (`<`), nên tự có sẵn hành vi của Rails.
- Mỗi **action** là một method trong controller. Action rỗng vẫn chạy được vì Rails theo **convention**: action tên gì thì tự render view tên đó (`home` → `home.html.erb`).
- Thêm một trang tĩnh mới cần đủ bộ ba **route → action → view**.
- Route `get 'static_pages/home'` nghĩa là: request **GET** tới `/static_pages/home` sẽ chuyển cho action `home`, đồng thời tạo helper `static_pages_home_url` dùng trong test.
- Root route (`root 'static_pages#home'`) là route cho URL `/`, tạo helper `root_url`.

### 4.2. Generate và destroy
- Tên controller viết **CamelCase** (`StaticPages`) hay **snake_case** (`static_pages`) đều cho kết quả giống nhau; Rails đổi bằng method `underscore`.
- `rails destroy` hoàn tác `rails generate` và dọn cả các dòng đã thêm vào `routes.rb`, nên không nên xóa file bằng tay.
- `destroy model User` không cần `name:string email:string` vì các tham số này chỉ quyết định nội dung file (cột trong migration), còn tên và vị trí file chỉ phụ thuộc vào `User`. Với controller thì phải truyền lại tên action vì nó quyết định các dòng route cần gỡ.
- Hoàn tác database: `db:rollback` (lùi 1 bước), `db:migrate VERSION=0` (về trạng thái ban đầu). Khi xóa model đã migrate, phải **rollback trước, destroy sau**.

### 4.3. HTTP verb
| Verb | Ý nghĩa |
|---|---|
| GET | Đọc dữ liệu (mở một trang) |
| POST | Gửi dữ liệu để tạo mới (submit form) |
| PATCH | Cập nhật dữ liệu |
| DELETE | Xóa dữ liệu |

Trình duyệt chỉ gửi native được GET và POST; Rails dùng trường ẩn `_method` để giả lập PATCH và DELETE.

### 4.4. Test tự động và TDD
- **Lợi ích:** chống regression (tính năng cũ bị hỏng), dám refactor, và test đóng vai "người dùng đầu tiên" của code nên giúp nhìn ra thiết kế.
- **TDD:** viết test fail (**Red**) → viết code cho pass (**Green**) → dọn code mà vẫn xanh (**Refactor**). Test từng đỏ rồi mới xanh thì mới chắc nó thực sự kiểm tra đúng thứ cần kiểm tra (bài tập root route).
- **Khi nào viết test trước:** test ngắn hơn code; liên quan bảo mật; sửa bug (viết test tái hiện bug trước); trước khi refactor. **Viết code trước** khi chưa rõ hành vi mong muốn. **Hạn chế test** với code hay đổi như cấu trúc HTML chi tiết.
- Thứ tự thường dùng: controller/model test trước, integration test sau.
- Cú pháp test: `get <url>` giả lập request GET; `assert_response :success` kiểm tra HTTP 200; `assert_select "title", "..."` kiểm tra thẻ HTML có nội dung đúng như mong đợi.
- `setup` là method chạy tự động trước mỗi test; biến `@base_title` (instance variable) dùng chung cho các test, chèn vào chuỗi bằng **string interpolation** `#{@base_title}` (chỉ hoạt động với dấu nháy kép).

### 4.5. Embedded Ruby (ERb) và Layout
- **ERb** là lý do file có đuôi `.html.erb`: `<% ... %>` chỉ **chạy** code, `<%= ... %>` chạy code và **chèn kết quả** vào trang.
- `provide(:title, "Home")` ở view gắn giá trị cho nhãn `:title`; `yield(:title)` ở layout lấy giá trị đó ra.
- **Layout** (`application.html.erb`) chứa khung HTML dùng chung; `<%= yield %>` là chỗ Rails chèn nội dung từng view. Layout còn nạp stylesheet, JavaScript, và các thẻ bảo mật chống **CSRF** (`csrf_meta_tags`) và **XSS** (`csp_meta_tag`).
- Nguyên tắc **DRY (Don't Repeat Yourself)**: mỗi thông tin chỉ nên nằm ở một chỗ. Ở đây, khung HTML và base title lặp 3 lần được gom về 1 chỗ trong layout. Cách làm là đưa 3 trang về cùng cấu trúc trước, rồi mới gộp một lần.
- Tạm đổi tên layout (`mv ... layout_file`) để thấy rõ sự lặp lại giữa các trang và hiểu layout sinh ra để làm gì.
- Test xanh sau refactor không chứng minh code đúng 100%, nhưng tăng mạnh độ tin cậy mà không phải mở từng trang kiểm tra bằng mắt.

### 4.6. Các lệnh viết tắt
`rails s` (server), `rails c` (console), `rails g` (generate), `rails t` (test), `bundle` (bundle install).

### 4.7. Khác biệt giữa sách (Rails 6) và thực tế (Rails 8)
- Rails 8 dùng **Importmap** thay Webpacker, nên layout không còn `javascript_pack_tag`; giữ nguyên các dòng Rails 8 sinh ra, chỉ sửa dòng `<title>`.
- Output của `rails generate` có thể không còn bước `assets/scss` như sách.
- Sách viết cho Rails 6 nên một số cấu hình trong 3.6 (Spring trong Guardfile) có thể không còn phù hợp.

---

## 5. Khó khăn và cách giải quyết

| Vấn đề | Nguyên nhân | Cách giải quyết |
|---|---|---|
| `bundle exec guard init` báo `command not found: guard` | Gem `guard` chưa có trong Gemfile / chưa `bundle install` | Thêm `guard`, `guard-minitest` vào nhóm `:test` rồi `bundle install` |

---

## 6. Tổng kết

### Đã hoàn thành
- [x] Set up `sample_app`, README, push GitHub
- [x] Tạo `StaticPagesController` với Home, Help, About, Contact
- [x] Viết test cho từng trang (status và title) theo chu trình Red → Green → Refactor
- [x] Dùng layout, `provide`/`yield` để loại bỏ lặp code
- [x] Đặt root route và viết test cho root route
- [x] Hoàn thành các bài tập của chương
- [x] 3.6 Advanced testing setup (minitest reporters, Guard)

### Câu hỏi cho mentor
- Trong dự án thực tế, team có viết test cho cả view/title như trong sách, hay chỉ test controller/model? Theo Box 3.3 thì code hay thay đổi nên hạn chế test.
- Team có dùng Guard hoặc công cụ tự chạy test tương tự không, hay chạy `rails test` thủ công và để CI lo?

### Kế hoạch tiếp theo
- Chapter 4: Rails-flavored Ruby