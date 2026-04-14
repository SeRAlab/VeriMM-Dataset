module top_module(
  input [15:0] A,
  input [15:0] B,
  output [15:0] C
);wire [15:0] temp [0:3][0:3];
  wire [15:0] row [0:3];
  wire [15:0] col [0:3];
  
  genvar i, j, k;
  generate
    for (i = 0; i < 4; i = i + 1) begin : row_loop
      for (j = 0; j < 4; j = j + 1) begin : col_loop
        assign temp[i][j] = A[i*4 + 0] * B[0*4 + j] +
                            A[i*4 + 1] * B[1*4 + j] +
                            A[i*4 + 2] * B[2*4 + j] +
                            A[i*4 + 3] * B[3*4 + j];
      end
    end
    for (i = 0; i < 4; i = i + 1) begin : assign_row
      assign row[i] = {temp[i][0], temp[i][1], temp[i][2], temp[i][3]};
    end
    for (j = 0; j < 4; j = j + 1) begin : assign_col
      assign col[j] = {temp[0][j], temp[1][j], temp[2][j], temp[3][j]};
    end
    for (i = 0; i < 4; i = i + 1) begin : output_loop
      for (j = 0; j < 4; j = j + 1) begin : output_loop
        assign C[i*4 + j] = row[i] * col[j];
      end
    end
  endgenerate

endmodule