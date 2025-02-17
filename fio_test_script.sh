#!/bin/bash
# FIO 測試腳本 - 自動執行多種測試並輸出結果

OUTPUT_DIR="fio_results"
mkdir -p $OUTPUT_DIR

# 測試參數
TEST_DIR="/mnt/test"
SIZE="2G"
RUNTIME="60"
JOBS=4

# 測試類型清單
tests=(
  "--rw=randread --bs=4k"
  "--rw=randwrite --bs=4k"
  "--rw=randrw --bs=4k"
  "--rw=read --bs=1M"
  "--rw=write --bs=1M"
)

for i in "${!tests[@]}"; do
  test_params=${tests[$i]}
  test_name="test_$(($i+1))"
  echo "Running $test_name with params: $test_params"

  fio --name=$test_name \
      --directory=$TEST_DIR \
      --ioengine=libaio \
      $test_params \
      --size=$SIZE \
      --runtime=$RUNTIME \
      --time_based \
      --numjobs=$JOBS \
      --group_reporting \
      > $OUTPUT_DIR/${test_name}.log

done

echo "All tests completed. Results saved in $OUTPUT_DIR."

