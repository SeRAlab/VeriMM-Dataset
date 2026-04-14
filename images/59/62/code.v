module top_module(
  input [3:0] data,
  output reg [2:0] code
);always @* begin
  if (data[3]) code = 3'b100;
  else if (data[2]) code = 3'b011;
  else if (data[1]) code = 3'b010;
  else if (data[0]) code = 3'b001;
  else code = 3'b000;
end

endmodule