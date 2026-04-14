module top_module(

input wire iRead,
input wire iWrite,
input wire[7:0]iDataRAM,

input wire[7:0]iDataALU,
input wire [7:0]iRegister,
output wire [7:0]oRegister

) ;assign oRegister= (iRead||iWrite) ? ( iRead ? iDataRAM:iDataALU)  :iRegister;






endmodule