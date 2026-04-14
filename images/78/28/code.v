module top_module(
    input [3:0] A,
    input [3:0] B,
    input sel,
    input clk,
    input reset,
    output reg [3:0] out,
    output reg [3:0] out_a,
    output reg [3:0] out_b
);always @(posedge clk or negedge reset) begin
    if (!reset) begin
        out <= 4'b0000;
        out_a <= 4'b0000;
        out_b <= 4'b0000;
    end else begin
        if (sel) begin
            out <= B;
            out_a <= 4'b0000;
            out_b <= B;
        end else begin
            out <= A;
            out_a <= A;
            out_b <= 4'b0000;
        end
    end
end

endmodule