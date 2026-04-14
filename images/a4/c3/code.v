module top_module(
    input [31:0] ext_data,
    input [31:0] rt_data,
    input aluSrc,
    input aluZeroinput,
    output [31:0]alu_input2
);wire [31:0] muxext_data,muxzero;
    assign muxext_data=aluSrc?ext_data:rt_data;
    assign muxzero=aluZeroinput?32'h00000000:muxext_data;
    assign alu_input2=muxzero;
endmodule