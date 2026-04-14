module top_module(regWrite, saidaOverflowModule, saidaMuxOverflow);input [0:0] regWrite;
input [0:0] saidaOverflowModule;
output [0:0] saidaMuxOverflow;

wire [0:0] regWrite, saidaOverflowModule;
wire [0:0] saidaMuxOverflow;



assign saidaMuxOverflow [0:0] = (saidaOverflowModule==1) ? 0 : regWrite;


endmodule