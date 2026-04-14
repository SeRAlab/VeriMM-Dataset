module top_module(
  input [3:0] in_data,
  output reg [1:0] out_data
);always @* begin
  case (in_data)
    4'b0000, 4'b0100, 4'b1000, 4'b1100: out_data = 2'b00;
    4'b0001, 4'b0101, 4'b1001, 4'b1101: out_data = 2'b01;
    4'b0010, 4'b0110, 4'b1010, 4'b1110: out_data = 2'b10;
    4'b0011, 4'b0111, 4'b1011, 4'b1111: out_data = 2'b11;
  endcase
end

endmodule