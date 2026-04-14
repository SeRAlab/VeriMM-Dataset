module pipeline_processor (
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1_reg;
    reg [7:0] stage2_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_reg <= 8'b0;
            stage2_reg <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1_reg <= data_in + 1; // First stage: Increment input
            stage2_reg <= stage1_reg;   // Second stage: Pass through
            data_out <= stage2_reg * 2; // Output doubled value
        end
    end
endmodule