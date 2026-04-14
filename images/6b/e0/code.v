module top_module(
	Inst_i,
	Branch_o,
	Jump_o,
	Control_o
);input		     [5:0]   Inst_i;
output reg	         Branch_o,Jump_o;
output reg 	[7:0]   Control_o;












always@(*) begin 
	Branch_o = 0;
	Jump_o = 0;
	if(Inst_i == 6'b000000)begin
		Control_o[0] = 1;
		Control_o[1] = 0;
		Control_o[2] = 0;
		Control_o[3] = 0;
		Control_o[4] = 0;
		Control_o[6:5] = 2'b10;
		Control_o[7] = 1;
	end
	
	if(Inst_i == 6'b001000)begin 
		Control_o[0] = 1;
		Control_o[1] = 0;
		Control_o[2] = 0;
		Control_o[3] = 0;
		Control_o[4] = 1;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0;
	end
	
	if(Inst_i == 6'b101011)begin 
		Control_o[0] = 0;
		Control_o[1] = 0;
		Control_o[2] = 0;
		Control_o[3] = 1;
		Control_o[4] = 1;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0; 
	end
	
	if(Inst_i == 6'b100011)begin 
		Control_o[0] = 1;
		Control_o[1] = 1;
		Control_o[2] = 1;
		Control_o[3] = 0;
		Control_o[4] = 1;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0;
	end
	
	if(Inst_i == 6'b000010)begin 
		Jump_o = 1;
		Control_o[0] = 0;
		Control_o[1] = 0; 
		Control_o[2] = 0; 
		Control_o[3] = 0;
		Control_o[4] = 0;
		Control_o[6:5] = 2'b00;
		Control_o[7] = 0; 
	end
	
	if(Inst_i == 6'b000100)begin 
		Branch_o = 1;
		Control_o[0] = 0;
		Control_o[1] = 0; 
		Control_o[2] = 0; 
		Control_o[3] = 0;
		Control_o[4] = 0;
		Control_o[6:5] = 2'b01;
		Control_o[7] = 0; 
	end
end


endmodule