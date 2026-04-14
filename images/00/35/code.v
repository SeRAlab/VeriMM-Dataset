module pipeline_adder (
    input clk,
    input reset,
    input valid,
    input [7:0] a,
    input [7:0] b,
    output reg [8:0] sum,
    output reg ready
);

    reg [7:0] stage1_a;
    reg [7:0] stage1_b;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sum <= 9'b0;
            ready <= 1'b0;
        end else if (valid) begin
            stage1_a <= a;
            stage1_b <= b;
            sum <= stage1_a + stage1_b; // Stage 2 computation
            ready <= 1'b1; // Output is ready
        end else begin
            ready <= 1'b0; // Not ready if valid is low
        end
    end
endmodule