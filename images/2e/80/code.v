module pipeline_processor (
    input clk,
    input rst,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stage1_reg;

    // Stage 1: Add 3
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 5'd0;
        end else begin
            stage1_reg <= data_in + 5'd3;
        end
    end

    // Stage 2: Multiply by 2
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'd0;
        end else begin
            data_out <= stage1_reg * 5'd2;
        end
    end
endmodule