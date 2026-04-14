module top_module(read_data_1temp,read_data_2temp,tempAluOut,read_data_1,read_data_2,AluOut,Zero);output [31:0]read_data_1temp;
output [31:0]read_data_2temp;
output [31:0]tempAluOut;
input [31:0] read_data_1;
input [31:0] read_data_2;
input [31:0] AluOut;
input Zero;

assign tempAluOut = (Zero == 1) ? ((read_data_1 - read_data_2) + 1): read_data_1 - read_data_2 ;
assign read_data_1temp=read_data_1;
assign read_data_2temp=read_data_2;

endmodule