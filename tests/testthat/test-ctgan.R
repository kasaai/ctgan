test_that("ctgan default params", {
  m <- ctgan()
  expect_attribute_identical(m, "batch_size", 500L)
  expect_attribute_identical(m, "embedding_dim", 128L)
  expect_attribute_identical(m, "gen_dim", c(256L, 256L))
  expect_attribute_identical(m, "dis_dim", c(256L, 256L))
  expect_attribute_identical(m, "l2scale", 1e-6)
})

test_that("ctgan param setting", {
  m <- ctgan(embedding_dim = 64, gen_dim = c(64, 64), dis_dim = c(32, 32),
             l2_scale = 1e-4, batch_size = 128)

  expect_attribute_identical(m, "batch_size", 128L)
  expect_attribute_identical(m, "embedding_dim", 64L)
  expect_attribute_identical(m, "gen_dim", c(64L, 64L))
  expect_attribute_identical(m, "dis_dim", c(32L, 32L))
  expect_attribute_identical(m, "l2scale", 1e-4)
})
