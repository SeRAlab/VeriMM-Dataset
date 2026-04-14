module top_module(out, in, clk, btn0, btn1, btn2, btn3, led0, led1, led2, led3);output reg [6:0] out;
	
	
   input wire [3:0] in;
	
	
   input wire clk;
	
	
   input wire btn0;
   input wire btn1;
   input wire btn2;
   input wire btn3;
	
	
   output reg led0;
   output reg led1;
   output reg led2;
   output reg led3;
	
	
	
   reg ledAux0;
   reg ledAux1;
   reg ledAux2;
   reg ledAux3;
 
always @(posedge clk)
	begin
	   
		if(btn0 == 1)
			begin
				
				ledAux0 = 0;
				ledAux1 = 1;
				ledAux2 = 1;
				ledAux3 = 1;
			end
		
		else if (btn1 == 1)
			begin
				
				ledAux0 = 1;
				ledAux1 = 0;
				ledAux2 = 1;
				ledAux3 = 1;
			end
		
		else if (btn2 == 1)
			begin
				
				ledAux0 = 1;
				ledAux1 = 1;
				ledAux2 = 0;
				ledAux3 = 1;
			end
		
		else if (btn3 == 1)
			begin
				
				ledAux0 = 1;
				ledAux1 = 1;
				ledAux2 = 1;
				ledAux3 = 0;
			end
		
		led0 = ledAux0;
		led1 = ledAux1;
		led2 = ledAux2;
		led3 = ledAux3;
		
		
		case (in)
			4'h0: out = 7'b1000000;
			4'h1: out = 7'b1111001;
			4'h2: out = 7'b0100100;
			4'h3: out = 7'b0110000;
			4'h4: out = 7'b0011001;
			4'h5: out = 7'b0010010;
			4'h6: out = 7'b0000010;
			4'h7: out = 7'b1111000;
			4'h8: out = 7'b0000000;
			4'h9: out = 7'b0010000;
			4'hA: out = 7'b0001000;
			4'hB: out = 7'b0000011;
			4'hC: out = 7'b1000110;
			4'hD: out = 7'b0100001;
			4'hE: out = 7'b0000110;
			4'hF: out = 7'b0001110;
			default: out = 7'b100000;
		endcase
	end
endmodule