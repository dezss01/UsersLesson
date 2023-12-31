# frozen_string_literal: true

# для того что бы приметь этото код нужно запустить rails db:seed
# 30.times do
#   title = Faker::Hipster.sentence(word_count: 5)
#   body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
#   Question.create title: title, body: body
# end

# Просчитаем хеши для email уже присутствующих в БД
# применяя send мы можем вызвать метод из private
# User.find_each do |u|
#   u.send(:set_gravatar_hash)
#   u.save
# end
30.times do
  title = Faker::Hipster.word
  Tag.create title: title
end
