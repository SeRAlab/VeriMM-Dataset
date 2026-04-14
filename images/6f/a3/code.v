module top_module(input [3:0] a, output [1:0] o);wire [1:0] sum;
  wire [1:0] diff;

  assign sum = a[1:0] + 2'b00;
  assign diff = a[3:2] - a[1:0];

  assign o = {sum, diff};

endmodule