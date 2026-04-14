module top_module(
	input 		clk,
	input [31:0]	float,

	output reg [31:0]	fixed_out
	);reg [31:0]	fixed;
  wire [30:0]	fixed_pos;
  reg [30:0]	fixed_pos_bar;

  wire [31:0]	fixed_pos_2;
  wire [31:0]	fixed_pos_3;
  wire [8:0]	shift;
  wire		big,tiny;

  wire		cin;
  reg		cin_bar;
  wire		cout;
  reg		neg_ovfl_mask;
  

  
  assign	shift = 8'h94 - float[30:23];
  assign	big = shift[8];
  assign	tiny = |(shift[7:5]);

  
  assign {fixed_pos, cin} = lsr32({1'b1, float[22:0],8'b0}, shift[4:0]);

  
  always @(fixed_pos or cin or big or tiny or float) begin
    cin_bar = ~cin;
    fixed_pos_bar = ~fixed_pos;
    casex ({float[31],big,tiny}) 
      3'b000: begin 
	fixed = fixed_pos + cin;
	if (fixed[31])
	  fixed = 32'h7fffffff;
      end 
      3'b100: begin 
	fixed = fixed_pos_bar + cin_bar;
	fixed[31] = ~fixed[31];
      end 
      3'b01x: 
	fixed = 32'h7fffffff;
      3'b11x: 
	fixed = 32'h80000000;
      3'bxx1: 
	fixed = 32'h0;
    endcase 
  end 

  always @(posedge clk) fixed_out <= fixed;

  function [31:0] lsr32;
  
  
    input [31:0] a;
    input [4:0]	 s;
    reg [4:0]	 s1;
    reg [31:0]	 a1;
    reg [31:0]	 a2;
    reg [31:0]	 a4;
    reg [31:0]	 a8;
    reg [31:0]	 a16;
  begin

    if (s[0])
      a1 = {1'b0, a[31:1]};
    else
      a1 = a;

    if (s[1])
      a2 = {{2{1'b0}}, a1[31:2]};
    else
      a2 = a1;

    if (s[2])
      a4 = {{4{1'b0}}, a2[31:4]};
    else
      a4 = a2;

    if (s[3])
      a8 = {{8{1'b0}}, a4[31:8]};
    else
      a8 = a4;

    if (s[4])
      a16 = {{16{1'b0}}, a8[31:16]};
    else
      a16 = a8;

    lsr32 = a16;
    
  end
  endfunction 

endmodule