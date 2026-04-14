module top_module(input wire BUS0, input wire BUS1, input wire BUS2, input wire BUS3, output wire [3:0] BUS);assign BUS = {BUS3, BUS2, BUS1, BUS0};
endmodule