module pipeline_processor(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] add_out,
    output reg [7:0] mul_out
);
    reg [7:0] stage1_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_reg <= 8'b0;
            add_out <= 8'b0;
            mul_out <= 8'b0;
        end else begin
            // Stage 1: Addition
            stage1_reg <= data_in + 8'd5; // Add 5 to input
            add_out <= stage1_reg;

            // Stage 2: Multiplication
            mul_out <= stage1_reg * 8'd2; // Multiply by 2
        end
    end
endmodule