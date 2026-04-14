module pipeline_register (
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stage1_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_reg <= 8'b0;
            data_out <= 8'b0;
        end else begin
            stage1_reg <= data_in;         // Stage 1: Register the input
            data_out <= stage1_reg + 8'd5; // Stage 2: Add 5 to the output of stage 1
        end
    end
endmodule