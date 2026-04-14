module top_module(
  input clk,
  input reset,
  input brdsprt,
  input sprsel,
  input window_ena,
  input reg_address_in,
  input data_in,
  output [7:0] red,
  output [7:0] green,
  output [7:0] blue
);reg [7:0] clut_data;
reg [24:0] ham_rgb;
reg [7:0] clut_rgb;
reg [7:0] sprdata;
reg [7:0] plfdata;
reg [7:0] bplxor;
reg [7:0] bpldata;
reg [7:0] nsprite;
reg [7:0] dpf;
reg blank;
reg ecs;
reg ecsena;
reg brdrblnk;
reg display_ena;
reg ham_sel;

wire t_blank;

assign t_blank = blank | ecs & ecsena & brdrblnk & (~window_ena | ~display_ena);

always @(*) begin
  if (brdsprt && sprsel) // select border sprites
    clut_data = sprdata;
  else if (!window_ena) // we are outside of the visible window region, display border colour
    clut_data = 8'b000000;
  else if (sprsel) // select sprites
    clut_data = sprdata;
  else // select playfield
    clut_data = plfdata ^ bplxor;
end

reg window_del;
reg sprsel_del;

always @(posedge clk) begin
  window_del <= window_ena;
  sprsel_del <= sprsel;
end

// ham_rgb / clut_rgb multiplexer
wire  [24-1:0] out_rgb  = ham_sel && window_del && !sprsel_del ? ham_rgb : clut_rgb; //if no HAM mode, always select normal (table selected) rgb data

//--------------------------------------------------------------------------------------

// RGB video output
assign {red[7:0],green[7:0],blue[7:0]} = t_blank ? 24'h000000 : out_rgb;

endmodule