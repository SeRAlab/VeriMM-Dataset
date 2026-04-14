module gradient_descent (
    input wire clk,
    input wire [3:0] x,
    input wire [3:0] alpha,
    output reg [3:0] x_next
);

always @(posedge clk) begin
    x_next <= x - alpha;
end

endmodule