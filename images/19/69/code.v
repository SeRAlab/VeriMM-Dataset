module pipeline (
    input clk,
    input [3:0] in,
    output reg [3:0] out
);
    reg [3:0] stage1;

    always @(posedge clk) begin
        stage1 <= in + 1; // First stage: Increment by 1
    end

    always @(posedge clk) begin
        out <= stage1 - 1; // Second stage: Decrement by 1
    end
endmodule