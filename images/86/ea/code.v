module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk,                  // Added clk input
    output reg [3:0] and_result
);reg [3:0] and_temp;

always @(*) begin
    and_temp = a & b;
end

always @(posedge clk) begin
    and_result <= and_temp;
end

endmodule