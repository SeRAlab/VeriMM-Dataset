module top_module(
		CLK,
		RST,
		SW,
		xAxis,
		yAxis,
		zAxis,
		DOUT,
		LED
);input        CLK;
   input        RST;
   input [1:0]  SW;
   input [9:0]  xAxis;
   input [9:0]  yAxis;
   input [9:0]  zAxis;
   output [9:0] DOUT;
   output [2:0] LED;
   




   reg [9:0]    DOUT;
   reg [2:0]    LED;
   




		
		
		
		always @(posedge CLK or posedge RST)
			if (RST == 1'b1)
			begin
				LED <= 3'b000;
				DOUT <= 10'b0000000000;
			end
			else 
			begin
				
				if (SW == 2'b00) begin
					LED <= 3'b001;
					if (xAxis[9] == 1'b1)
						DOUT <= {xAxis[9], (9'b000000000 - xAxis[8:0])};
					else
						DOUT <= xAxis;
				end
				
				else if (SW == 2'b01) begin
					LED <= 3'b010;
					if (yAxis[9] == 1'b1)
						DOUT <= {yAxis[9], (9'b000000000 - yAxis[8:0])};
					else
						DOUT <= yAxis;
				end
				
				else if (SW == 2'b10) begin
					LED <= 3'b100;
					if (zAxis[9] == 1'b1)
						DOUT <= {zAxis[9], (9'b000000000 - zAxis[8:0])};
					else
						DOUT <= zAxis;
				end
				
				else begin
					LED <= 3'b001;
					if (xAxis[9] == 1'b1)
						DOUT <= {xAxis[9], (9'b000000000 - xAxis[8:0])};
					else
						DOUT <= xAxis;
				end
			end
		
endmodule