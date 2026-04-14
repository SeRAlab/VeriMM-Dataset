module nand_module (
    input [7:0] a,
    input [7:0] b,
    input enable,
    input reset,
    output reg [7:0] nand_result
);

    always @(*) begin
        if (reset) begin
            nand_result = 0;
        end else if (enable) begin
            nand_result = ~(a & b);
        end else begin
            nand_result = nand_result; // Maintain the current value
        end
    end
endmodule