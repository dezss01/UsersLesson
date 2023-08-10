# для того что бы приметь этото код нужно запустить rails db:seed
30.times do
  title = Faker::Hipster.sentence(word_count: 5)
  body = Faker::Lorem.paragraph(sentence_count: 5, supplemental: true, random_sentences_to_add: 4)
  Question.create title: title, body: body
end