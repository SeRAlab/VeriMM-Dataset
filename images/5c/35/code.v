module top_module(input clk, reset_n, write, input [7:0] data, input [1:0] select0, select1, wr_select,
				output reg [7:0] selected0, selected1, output reg [7:0] delay, position, register0);reg [7:0] reg0 ;  
reg [7:0] reg1 ; 
reg [7:0] reg2 ; 
													  
reg [7:0] reg3 ; 

always @(posedge clk)
begin
	if (!reset_n)
	begin
	reg0<=8'h00;
	reg1<=8'h00;
	reg2<=8'h00;  
	reg3<=8'h00;
	end
	
else if (write)
	begin
	case (wr_select)
	2'b00: reg0<=data;
	2'b01: reg1<=data;
	2'b10: reg2<=data;
	2'b11: reg3<=data;
	endcase
	end

	case (select0)
	2'b00: selected0<=reg0;
	2'b01: selected0<=reg1;
	2'b10: selected0<=reg2;
	2'b11: selected0<=reg3;
	endcase
	
	case (select1)
	2'b00: selected1<=reg0;
	2'b01: selected1<=reg1;
	2'b10: selected1<=reg2;
	2'b11: selected1<=reg3;
	endcase
	
	register0 <= reg0;
	position <= reg2;
	delay <= reg3;
end
endmodule