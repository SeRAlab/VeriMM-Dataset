module top_module(
  input [99:0] a,
  input [99:0] b,
  output [199:0] product
);reg [199:0] temp_product;
  integer i, j;

  always @(*) begin
    temp_product = 0;
    for (i = 0; i < 100; i = i + 1) begin
      for (j = 0; j < 100; j = j + 1) begin
        if (a[i] & b[j]) begin
          temp_product[i+j] = temp_product[i+j] ^ 1'b1;
        end
      end
    end
  end

  assign product = temp_product;

endmodule