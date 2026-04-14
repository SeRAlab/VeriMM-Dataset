module top_module(Out, In, Select);output	Out;	
	reg Out;
	input [3:0] In;		
	input [1:0] Select; 
	
	
	always @ (In or Select)
	case (Select)
	2'b00: Out=In[0];
	2'b01: Out=In[1];
	2'b10: Out=In[2];
	2'b11: Out=In[3];
	endcase
endmodule