module top_module(phase,index_qua,index_rea,index_cor);input  [15:0] phase;
output [2:0] index_qua;
output [5:0] index_rea;
output [6:0] index_cor;

wire [12:0] Index;

assign Index = (phase[13])?~phase[12:0]:phase[12:0];
assign index_qua = phase[15:13];
assign index_rea = Index[12:7];
assign index_cor = Index[6:0];

endmodule