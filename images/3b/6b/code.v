module pipeline (
    input clk,
    input reset,
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] result
);
    reg [4:0] sum; // 5 bits to hold the sum of two 4-bit numbers
    reg [7:0] squared; // 8 bits to hold the squared value

    // Stage 1: Compute sum
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 5'b0;
        end else begin
            sum <= a + b;
        end
    end

    // Stage 2: Compute square
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            squared <= 8'b0;
        end else begin
            squared <= sum * sum; // square the sum
        end
    end

    // Output the final result
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'b0;
        end else begin
            result <= squared;
        end
    end
endmodule