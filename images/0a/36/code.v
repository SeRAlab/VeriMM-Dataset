module pipelined_processor (
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] stage1_reg;

    // Stage 1: Double the input
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 4'b0000;
        end else begin
            stage1_reg <= data_in << 1; // Doubling the input
        end
    end

    // Stage 2: Add 3 to the output of stage 1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 4'b0000;
        end else begin
            data_out <= stage1_reg + 4'b0011; // Adding 3
        end
    end
endmodule