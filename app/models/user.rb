require "validator/email_validator"

class User < ApplicationRecord
  before_validation :downcase_email

  # gem bcrypt
  # 1. passwordを暗号化する
  # 2. password_digest => password
  # 3. password_confirmation => パスワードの一致確認
  # 4. 一致のバリデーション追加
  # 5. authenticate()
  # 6. 最大文字数 72文字
  # 7. User.create() => 入力必須バリデーション, User.update() => X
  has_secure_password

  # 追加
  # validates
  # User.create(name: "
  # 名前を入力してください。文字数は30文字まで
  validates :name,  presence: true,                    # 入力必須
                    length: {                          # 文字数
                      maximum: 30,                     # 最大文字数
                      allow_blank: true                # nil, 空白文字の場合スキップ
                    }

  validates :email, presence: true,
                    email: { allow_blank:true}
  # 追加
  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password,  presence: true,                # 空白文字を許容しない
                        length: {                      # 最小文字数
                          minimum: 8,
                          allow_blank: true
                        },
                        format: {                      # 書式チェック
                          with: VALID_PASSWORD_REGEX,
                          message: :invalid_password,
                          allow_blank: true
                        },
                        allow_nil: true                # nilの場合スキップ

  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end

  private

  # email小文字化
  def downcase_email
    self.email.downcase! if email
  end
end
