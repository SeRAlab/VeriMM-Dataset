module pipelined_processor (
    input clk,
    input rst,
    input [4:0] in,
    output reg [4:0] out
);
    reg [4:0] stage1;

    // First stage: doubling the input
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1 <= 5'b0;
        end else begin
            stage1 <= in << 1; // Double the input
        end
    end

    // Second stage: adding 3
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 5'b0;
        end else begin
            out <= stage1 + 5'd3; // Add 3 to the result from stage 1
        end
    end
endmodule