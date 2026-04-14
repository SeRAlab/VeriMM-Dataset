module top_module(
    input clk,
    input rst,

    input [INST_DATA_WIDTH-1:0] inst,

    input reg_we,
    input [1:0] reg_we_dst,
    input [DATA_DATA_WIDTH-1:0] mem_result,

    output reg_we_o,
    output [4:0] reg_addrw,
    output [DATA_DATA_WIDTH-1:0] reg_dataw
    );parameter INST_ADDR_WIDTH = 32;
    parameter INST_DATA_WIDTH = 32;
    parameter DATA_ADDR_WIDTH = 20;
    parameter DATA_DATA_WIDTH = 48;

    assign reg_we_o     = reg_we,
           reg_addrw    = (reg_we_dst == 0) ? inst[15:11] :
                          (reg_we_dst == 1) ? inst[20:16] :
                                              5'd31,
           reg_dataw    = mem_result;endmodule