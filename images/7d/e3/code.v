module top_module(alu_in1,alu_in2,alu_sel,alu_out,z,ovf);input [15:0] alu_in1;
	input [15:0] alu_in2;
	input [1:0] alu_sel;
	output [15:0] alu_out;
	output z;
	output ovf;
    reg [16:0] alu_out_reg;
    reg z_out;
        

 assign z = z_out;
 assign alu_out = alu_out_reg[15:0];
 assign ovf = alu_out_reg[16];

 always @ (alu_sel or alu_in1 or alu_in2)
 begin : ALU
 case(alu_sel) 
    2'b00 : alu_out_reg = alu_in1 + alu_in2; 
    2'b01 : alu_out_reg = alu_in1 - alu_in2; 
    2'b10 : alu_out_reg = alu_in1 + 1'b1;    
 endcase 
end

always @(alu_out) begin : proc_
	if(alu_out==16'h0000)
		 z_out= 1'b1;
	else
		z_out= 1'b0;
end


endmodule