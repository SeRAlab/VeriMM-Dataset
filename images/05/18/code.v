module pipeline_processor (
    input clk,
    input reset,
    input [3:0] in_data,
    output reg [3:0] out_data
);
    reg [3:0] stage1_reg;
    reg [3:0] stage2_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_reg <= 4'b0000;
            stage2_reg <= 4'b0000;
            out_data <= 4'b0000;
        end else begin
            stage1_reg <= in_data + 4'b0001; // Stage 1: Add 1
            stage2_reg <= stage1_reg * 2;     // Stage 2: Multiply by 2
            out_data <= stage2_reg;           // Output the result
        end
    end
endmodule