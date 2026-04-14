module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    input clk,            // Added clk input
    output reg [3:0] out
);reg [3:0] sum1, sum2;

always @ (posedge clk) begin
    sum1 <= A + B;
    sum2 <= A - B;
end

always @ (posedge clk) begin
    if (C == 0) begin
        out <= sum1;
    end else begin
        out <= sum2;
    end
end

endmodule