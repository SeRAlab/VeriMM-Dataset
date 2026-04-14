module pipelined_processor (
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    input sel, // 0 for addition, 1 for subtraction
    output reg [7:0] result
);
    reg [7:0] a_reg, b_reg;
    reg op_sel;

    // Stage 1: Register inputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            op_sel <= 1'b0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            op_sel <= sel;
        end
    end

    // Stage 2: Perform operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 8'b0;
        end else begin
            if (op_sel == 1'b0) // Addition
                result <= a_reg + b_reg;
            else // Subtraction
                result <= a_reg - b_reg;
        end
    end
endmodule