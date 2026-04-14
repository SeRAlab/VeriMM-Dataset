module pipeline_processor (
    input clk,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1;

    always @(posedge clk) begin
        stage1 <= ~data_in;         // Stage 1: Bit-wise NOT
        data_out <= stage1 & 5'b10101; // Stage 2: AND with 5'b10101
    end
endmodule