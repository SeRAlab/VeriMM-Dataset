module binary_nand_gate (
    input [2:0] i,
    input [2:0] j,
    output reg [2:0] nand_out);always @(*) begin
        nand_out = ~(i & j);
    end

endmodule