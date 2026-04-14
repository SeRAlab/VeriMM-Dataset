module top_module(
    input [15:0] x1,
    input [15:0] y1,
    input [15:0] z1,
    input [15:0] x2,
    input [15:0] y2,
    input [15:0] z2,
	 output reg[15:0] left_x,
    output reg[15:0] left_y,
    output reg[15:0] left_z,
    output reg[15:0] right_x,
    output reg[15:0] right_y,
    output reg[15:0] right_z
    );always @(*) begin
  if (x1 > x2) begin
    left_x <= x2;
	 left_y <= y2;
	 left_z <= z2;
	 right_x <= x1;
	 right_y <= y1;
	 right_z <= z1;
  end else begin
    left_x <= x1;
	 left_y <= y1;
	 left_z <= z1;
	 right_x <= x2;
	 right_y <= y2;
	 right_z <= z2;
  end
end

endmodule