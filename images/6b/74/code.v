module multiplier_4bit(A, B, Product);
input [3:0] A;
input [3:0] B;
output [7:0] Product;

assign Product = A * B;

endmodule