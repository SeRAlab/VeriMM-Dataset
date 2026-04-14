module pipeline_processor (
    input wire clk,
    input wire reset,
    input wire [3:0] in_data,
    output reg [3:0] out_data
);
    reg [3:0] stage1_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stage1_data <= 4'b0000;
            out_data <= 4'b0000;
        end else begin
            stage1_data <= in_data + 1; // Stage 1: Increment input
            out_data <= stage1_data * 2; // Stage 2: Double the result
        end
    end
endmodule