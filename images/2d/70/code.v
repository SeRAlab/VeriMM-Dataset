module pipeline_processor (
    input clk,
    input reset,
    input [4:0] in_data,
    output reg [4:0] out_data
);
    reg [4:0] stage1_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_data <= 5'b0;
            out_data <= 5'b0;
        end else begin
            stage1_data <= in_data + 1; // Stage 1: Add 1
            out_data <= stage1_data * 2; // Stage 2: Multiply by 2
        end
    end
endmodule