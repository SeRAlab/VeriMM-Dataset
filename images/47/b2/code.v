module top_module(
  input [3:0] input_lines,
  output [15:0] output_lines
);assign output_lines[0] = (input_lines == 4'b0000) ? 1'b1 : 1'b0;
  assign output_lines[1] = (input_lines == 4'b0001) ? 1'b1 : 1'b0;
  assign output_lines[2] = (input_lines == 4'b0010) ? 1'b1 : 1'b0;
  assign output_lines[3] = (input_lines == 4'b0011) ? 1'b1 : 1'b0;
  assign output_lines[4] = (input_lines == 4'b0100) ? 1'b1 : 1'b0;
  assign output_lines[5] = (input_lines == 4'b0101) ? 1'b1 : 1'b0;
  assign output_lines[6] = (input_lines == 4'b0110) ? 1'b1 : 1'b0;
  assign output_lines[7] = (input_lines == 4'b0111) ? 1'b1 : 1'b0;
  assign output_lines[8] = (input_lines == 4'b1000) ? 1'b1 : 1'b0;
  assign output_lines[9] = (input_lines == 4'b1001) ? 1'b1 : 1'b0;
  assign output_lines[10] = (input_lines == 4'b1010) ? 1'b1 : 1'b0;
  assign output_lines[11] = (input_lines == 4'b1011) ? 1'b1 : 1'b0;
  assign output_lines[12] = (input_lines == 4'b1100) ? 1'b1 : 1'b0;
  assign output_lines[13] = (input_lines == 4'b1101) ? 1'b1 : 1'b0;
  assign output_lines[14] = (input_lines == 4'b1110) ? 1'b1 : 1'b0;
  assign output_lines[15] = (input_lines == 4'b1111) ? 1'b1 : 1'b0;

endmodule