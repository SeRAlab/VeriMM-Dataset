module top_module(
	input	desc,			
	input	[3:0] shift,	
	input 	[15:0] new_val,		
	input 	[15:0] old_val,		
	output	[15:0] out		
);wire [35:0] shifted_new;	
wire [35:0] shifted_old;	
reg  [17:0] shift_onehot;	


always @(desc or shift)
	case ({desc,shift[3:0]})
		5'h00 : shift_onehot = 18'h10000;
		5'h01 : shift_onehot = 18'h08000;
		5'h02 : shift_onehot = 18'h04000;
		5'h03 : shift_onehot = 18'h02000;
		5'h04 : shift_onehot = 18'h01000;
		5'h05 : shift_onehot = 18'h00800;
		5'h06 : shift_onehot = 18'h00400;
		5'h07 : shift_onehot = 18'h00200;
		5'h08 : shift_onehot = 18'h00100;
		5'h09 : shift_onehot = 18'h00080;
		5'h0A : shift_onehot = 18'h00040;
		5'h0B : shift_onehot = 18'h00020;
		5'h0C : shift_onehot = 18'h00010;
		5'h0D : shift_onehot = 18'h00008;
		5'h0E : shift_onehot = 18'h00004;
		5'h0F : shift_onehot = 18'h00002;
		5'h10 : shift_onehot = 18'h00001;
		5'h11 : shift_onehot = 18'h00002;
		5'h12 : shift_onehot = 18'h00004;
		5'h13 : shift_onehot = 18'h00008;
		5'h14 : shift_onehot = 18'h00010;
		5'h15 : shift_onehot = 18'h00020;
		5'h16 : shift_onehot = 18'h00040;
		5'h17 : shift_onehot = 18'h00080;
		5'h18 : shift_onehot = 18'h00100;
		5'h19 : shift_onehot = 18'h00200;
		5'h1A : shift_onehot = 18'h00400;
		5'h1B : shift_onehot = 18'h00800;
		5'h1C : shift_onehot = 18'h01000;
		5'h1D : shift_onehot = 18'h02000;
		5'h1E : shift_onehot = 18'h04000;
		5'h1F : shift_onehot = 18'h08000;
 	endcase


assign shifted_new = ({2'b00,new_val[15:0]})*shift_onehot;


assign shifted_old = ({2'b00,old_val[15:0]})*shift_onehot;

assign out = desc ? shifted_new[15:0] | shifted_old[31:16] : shifted_new[31:16] | shifted_old[15:0];


endmodule