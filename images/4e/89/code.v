module top_module(
input  		I_in1,
input   	I_in2,
input   	I_sel,
output  	O_out
);assign O_out =  I_sel ? I_in1 : I_in2; 




endmodule