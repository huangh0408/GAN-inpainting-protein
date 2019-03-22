#!/bin/sh
bash extract_contact.sh
matlab -nosplash -nodesktop -r delete_unuseful_col_row
python concatenate_matrix.py

