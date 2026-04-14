module top_module(
    iTypeSignExtend,
    rs1,
    target
);input wire [31:0] iTypeSignExtend;
    input wire [31:0] rs1;
    output wire [31:0] target;
    
    assign target = rs1 + iTypeSignExtend;

endmodule