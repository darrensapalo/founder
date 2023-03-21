#!/usr/bin/env fish

# Copyright Tome.gg
# 
# Licensed through Apache License 2.0
# See: https://www.apache.org/licenses/LICENSE-2.0

# Software limitations
# - yq screws up the formatting of the YAML file after it reads, parses, and writes it out.
#
# Roadmap
# - Look for an alternative YAML parser and writer that preserves the formatting.

set training training/dsu-reports.yaml

set bak ../dsu-reports.bak.yaml
# Back up the file first
cp $training $bak

# Generate a UUID
set my_id (uuidgen)

set my_date (date +%Y-%m-%d)


set -l indent "      "  # the number of spaces to use for indentation


# Prompt the user for the done yesterday
echo "Enter the 'done yesterday' report (Ctrl-D to finish):"
read -z done_yesterday
echo " "

# Prompt the user for the doing today
echo "Enter the 'doing today' report  (Ctrl-D to finish): "
read -z my_doing_today
echo " "

# Prompt the user for the blockers
echo "Enter the blockers (leave empty to skip, Ctrl-D to finish): "
read -z my_blockers
echo " "

# Prompt the user for the remarks
echo "Enter the remarks (leave empty to skip, Ctrl-D to finish): " 
read -z my_remarks
echo " "

if test -n "$my_remarks"
  if test -n "$my_blockers"
    set template "
  - id: $my_id
    datetime: $my_date
    remarks: |
      $my_remarks
    done_yesterday: |
      $my_done_yesterday
    doing_today: |
      $my_doing_today
    blockers: |
      $my_blockers"
  else
    set template "
  - id: $my_id
    datetime: $my_date
    remarks: |
      $my_remarks
    done_yesterday: |
      $my_done_yesterday
    doing_today: |
      $my_doing_today"
  end
else
  if test -n "$my_blockers"
    set template "
  - id: $my_id
    datetime: $my_date
    done_yesterday: |
      $my_done_yesterday
    doing_today: |
      $my_doing_today
    blockers: |
      $my_blockers"
  else
    set template "
  - id: $my_id
    datetime: $my_date
    done_yesterday: |
      $my_done_yesterday
    doing_today: |
      $my_doing_today"
  end
end

echo $template >> training/dsu-reports.yaml

cat training/dsu-reports.yaml

set validation_result (tome validate . )

if string match -q -- "*SUCCESS*" "$validation_result"
  echo " "
  echo "🚀 Report added to training/dsu-reports.yaml"
  echo " "
  yq -M -C '.content[-1]' training/dsu-reports.yaml | sed 's/^/  /'
  rm $bak
else
  echo $validation_result
  echo " ❌ Validation failed! Invalid tome repository state!"
  cp $bak $training
  rm $bak
  exit 1
end
