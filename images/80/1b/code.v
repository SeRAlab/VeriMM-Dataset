module top_module(
    input [10:0] i_x,
    input [10:0] i_y,
    output reg [10:0] o_x1,
    output reg [10:0] o_x2,
    output reg [10:0] o_y1,
    output reg [10:0] o_y2,
    output reg [10:0] o_x3,
    output reg [10:0] o_x4,
    output reg [10:0] o_y3,
    output reg [10:0] o_y4
  );localparam H_SIZE = 5'h17;
  localparam V_SIZE = 5'h1f;
  localparam H2_SIZE = 5'h12;
  localparam V2_SIZE = 5'h1a;
  localparam IX = 9'h140;
  localparam IY = 8'hf0;
  localparam D_WIDTH = 10'h280;
  localparam D_HEIGHT = 9'h1e0;
  
  
  reg [10:0] x;
  
  reg [10:0] y;
  
  always @* begin
    x = i_x;
    y = i_y;
    o_x1 = x - 5'h17;
    o_x2 = x + 5'h17;
    o_y1 = y - 5'h1f;
    o_y2 = y + 5'h1f;
    o_x3 = x - 5'h12;
    o_x4 = x + 5'h12;
    o_y3 = y - 5'h1a;
    o_y4 = y + 5'h1a;
  end
endmodule