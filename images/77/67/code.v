module top_module(pc_from_pcsel,pc_plus_4,pc_const,rd1,pcsel);output reg [4:0] pc_from_pcsel;  
 input [31:0] rd1; 
 input [4:0] pc_plus_4; 
 input [4:0] pc_const; 
 input [1:0] pcsel;
 
 always @ (pc_plus_4,pc_const,rd1,pcsel)
 case(pcsel)
 2'b00: pc_from_pcsel <= pc_plus_4; 
 2'b01: pc_from_pcsel <= pc_const; 
 2'b10: pc_from_pcsel <= rd1[4:0];  
 endcase
endmodule