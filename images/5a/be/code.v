module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,          // Added clock input
    output reg [3:0] S
);reg [3:0] sum1, sum2;

always @ (posedge clk) begin
    sum1 <= A + B;
end

always @ (posedge clk) begin
    sum2 <= sum1;
end

always @ (posedge clk) begin
    if (sum2 > 15) begin
        S <= sum2[3:0];
    end else begin
        S <= sum2;
    end
end

endmodule