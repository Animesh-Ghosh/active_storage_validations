# frozen_string_literal: true

require 'test_helper'
require 'active_storage_validations/matchers'

class ActiveStorageValidations::Matchers::AttachedValidatorMatcher::Test < ActiveSupport::TestCase
  test 'positive match when providing class' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:avatar)
    matcher.with_message("must not be blank")
    assert matcher.matches?(User)
  end

  test 'negative match when providing class' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:image_regex)
    refute matcher.matches?(User)
  end

  test 'unknown attached when providing class' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:non_existing)
    refute matcher.matches?(User)
  end

  test 'positive match when providing instance' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:avatar)
    matcher.with_message("must not be blank")
    assert matcher.matches?(User.new)
  end

  test 'negative match when providing instance' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:image_regex)
    refute matcher.matches?(User.new)
  end

  test 'unknown attached when providing instance' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:non_existing)
    refute matcher.matches?(User.new)
  end

  test 'positive match with valid conditional validation' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:conditional_image)
    assert matcher.matches?(User.new(name: 'Foo'))
  end

  test 'negative match with invalid conditional validation' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:conditional_image)
    refute matcher.matches?(User.new)
  end

  test 'positive match when providing instance with attachment' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:avatar)
    matcher.with_message("must not be blank")
    user = User.new
    user.avatar.attach(io: Tempfile.new('.'), filename: 'image.png', content_type: 'image/png')
    user.proc_avatar.attach(io: Tempfile.new('.'), filename: 'image.png', content_type: 'image/png')
    assert matcher.matches?(user)
  end

  test 'positive match when providing persisted instance with attachment' do
    matcher = ActiveStorageValidations::Matchers::AttachedValidatorMatcher.new(:avatar)
    matcher.with_message("must not be blank")
    user = User.create!(
      name: 'Pietje',
      avatar: { io: Tempfile.new('.'), filename: 'image.png', content_type: 'image/png' },
      photos: [{ io: Tempfile.new('.'), filename: 'image.png', content_type: 'image/png' }],
      proc_avatar: { io: Tempfile.new('.'), filename: 'image.png', content_type: 'image/png' },
      proc_photos: [{ io: Tempfile.new('.'), filename: 'image.png', content_type: 'image/png' }]
    )
    assert matcher.matches?(user)
  end
end
