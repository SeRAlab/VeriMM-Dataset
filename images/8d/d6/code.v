module top_module(
  input [3:0] x,
  input [3:0] y,
  output [7:0] product
);wire [7:0] temp; // temporary 8-bit variable for intermediate calculations

assign temp[0] = x[0] & y; // calculate the first bit of the product
assign temp[1] = x[1] & y;
assign temp[2] = x[2] & y;
assign temp[3] = x[3] & y;

assign temp[4] = {4'b0, x} & {4'b0, y}; // calculate the second byte of the product
assign temp[5] = {3'b0, x} & {5'b0, y};
assign temp[6] = {2'b0, x} & {6'b0, y};
assign temp[7] = {1'b0, x} & {7'b0, y};

assign product = temp; // assign the final product to the output

endmodule