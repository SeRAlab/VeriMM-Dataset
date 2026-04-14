module top_module(input [3:0] input1, input [3:0] input2, output output1);wire [3:0] diff;
  wire carry_out;

  assign diff = input1 - input2; // Compute the difference

  // Determine if input1 is greater than, less than or equal to input2
  assign output1 = (diff[3] == 1'b1) ? 1'b0 : 1'b1; // If the MSB of diff is 1, input1 < input2

endmodule