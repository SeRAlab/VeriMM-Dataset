module pipeline_processor(
    input wire clk,
    input wire reset,
    input wire [7:0] in_data,
    output reg [7:0] out_data
);
    reg [7:0] stage1_reg;
    reg [7:0] stage2_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_reg <= 8'b0;
            stage2_reg <= 8'b0;
            out_data <= 8'b0;
        end else begin
            stage1_reg <= in_data + 8'd3;  // Stage 1: Add 3
            stage2_reg <= stage1_reg * 8'd2; // Stage 2: Multiply by 2
            out_data <= stage2_reg;
        end
    end
endmodule