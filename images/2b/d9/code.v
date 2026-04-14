module pipelined_increment_square (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [15:0] data_out
);
    reg [7:0] stage1_reg;

    // Stage 1: Increment
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 8'b0;
        end else begin
            stage1_reg <= data_in + 1;
        end
    end

    // Stage 2: Square
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0;
        end else begin
            data_out <= stage1_reg * stage1_reg;
        end
    end
endmodule