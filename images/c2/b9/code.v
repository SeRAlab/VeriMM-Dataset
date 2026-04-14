module adder(
    input signed [15:0] a,
    input signed [15:0] b,
    input clk,
    input rst,
    output reg signed [15:0] sum
);

always @(posedge clk) begin
    if (rst) begin
        sum <= 0;
    end else begin
        sum <= a + b;
    end
end

endmodule