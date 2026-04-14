module pipelined_multiplier (
    input clk,
    input reset,
    input valid,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] result,
    output reg ready
);
    reg [7:0] a_reg, b_reg;
    reg [15:0] product_reg;

    // Stage 1: Fetch
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            a_reg <= 0;
            b_reg <= 0;
            ready <= 0;
        end else if (valid) begin
            a_reg <= a;
            b_reg <= b;
            ready <= 0; // Not ready until the final output is done
        end
    end

    // Stage 2: Decode
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product_reg <= 0;
        end else if (valid) begin
            product_reg <= a_reg * b_reg;
        end
    end

    // Stage 5: Writeback
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 0;
        end else begin
            result <= product_reg;
            ready <= 1; // Signal that output is ready
        end
    end
endmodule