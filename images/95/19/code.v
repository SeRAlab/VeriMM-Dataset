module top_module(
    input wire MEMtoReg,
    input wire[31:0] load_data,
    input wire[31:0] ALU_result,
    output wire[31:0] write_data
);assign write_data = MEMtoReg ? load_data : ALU_result;
endmodule