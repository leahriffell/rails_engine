class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_id :object_id

  attribute :revenue do |object|
    object
  end
end
