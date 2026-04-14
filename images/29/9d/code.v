module pipeline_processor (
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] stage1_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 4'b0000;
            data_out <= 4'b0000;
        end else begin
            stage1_reg <= data_in + 1; // First stage: Increment
            data_out <= stage1_reg * 2; // Second stage: Double
        end
    end
endmodule