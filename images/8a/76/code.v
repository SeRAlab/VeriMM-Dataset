module top_module(
    clk_i,
    rst_i,
    we_i,  
    stb_i,
    ack_o,
    dat_i,
    dat_o,
    adr_i,
    a11,
    a12,
    b10,
    b11,
    b12
  );input clk_i;
  input rst_i;
  input we_i;
  input stb_i;
  output ack_o;
  input [15:0] dat_i;
  output [15:0] dat_o;
  input [2:0] adr_i;
  output [15:0] a11;
  output [15:0] a12;
  output [15:0] b10;
  output [15:0] b11;
  output [15:0] b12;

  reg [15:0] a11;
  reg [15:0] a12;
  reg [15:0] b10;
  reg [15:0] b11;
  reg [15:0] b12;

  wire ack_o;
  wire sel_a11;
  wire sel_a12;
  wire sel_b10;
  wire sel_b11;
  wire sel_b12;

  assign sel_a11 = (adr_i == 3'b000);
  assign sel_a12 = (adr_i == 3'b001);
  assign sel_b10 = (adr_i == 3'b010);
  assign sel_b11 = (adr_i == 3'b011);
  assign sel_b12 = (adr_i == 3'b100);

  assign ack_o = stb_i;

  always @(posedge clk_i or posedge rst_i)
    if (rst_i) begin
      a11 <= 16'hFF;
      a12 <= 16'h1F;
      b10 <= 16'h7F;
      b11 <= 16'h3;
      b12 <= 16'hFF;
    end
    else begin
      a11 <= (stb_i & we_i & sel_a11) ? dat_i : a11;
      a12 <= (stb_i & we_i & sel_a12) ? dat_i : a12;
      b10 <= (stb_i & we_i & sel_b10) ? dat_i : b10;
      b11 <= (stb_i & we_i & sel_b11) ? dat_i : b11;
      b12 <= (stb_i & we_i & sel_b12) ? dat_i : b12;
    end

  assign dat_o = sel_a11 ? a11 :
    (sel_a12 ? a12 :
    (sel_b10 ? b10 :
    (sel_b11 ? b11 :
    (sel_b12 ? b12 : 16'h0000))));

endmodule