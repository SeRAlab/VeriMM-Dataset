module top_module(
    input [15:0] bcd_in,
    input [3:0] decimal_points,
    input clk,
    output  reg [6:0] a_to_g,
    output reg decimal_point,
    output reg [3:0] anode
    );wire [1:0] counter;
reg [3:0] digit;
reg [19:0] clkdiv;	
	 
assign counter = clkdiv[19:18];   //count every 2.6 ms  (with 100 MHz clock)

//quad 4 to 1 MUX
always @(posedge clk)
    case(counter)
	0: {digit, decimal_point} = {bcd_in[3:0], decimal_points[0]};
	1: {digit, decimal_point} = {bcd_in[7:4], decimal_points[1]};
	2: {digit, decimal_point} = {bcd_in[11:8], decimal_points[2]};
	3: {digit, decimal_point} = {bcd_in[15:12], decimal_points[3]};
     endcase

//7-segment decoder 
always @(posedge clk)
     case(digit)
     	0: a_to_g = 7'b0000001;
     	1: a_to_g = 7'b1001111;
	2: a_to_g = 7'b0010010;
	3: a_to_g = 7'b0000110;
	4: a_to_g = 7'b1001100;
	5: a_to_g = 7'b0100100;
	6: a_to_g = 7'b0100000;
	7: a_to_g = 7'b0001111;
	8: a_to_g = 7'b0000000;
	9: a_to_g = 7'b0000100;
	default: a_to_g = 7'b0000001;  //default to 0
     endcase
	  
//digit selector
always @(posedge clk)
    case(counter)
    	0: anode = 4'b1110;
	1: anode = 4'b1101;
	2: anode = 4'b1011;
	3: anode = 4'b0111;
	default: anode = 4'b1111;  //all blank
     endcase
     
//clock divider 
always  @ (posedge clk)
   begin
	clkdiv <= clkdiv + 20'b1;
    end 
	  
endmodule