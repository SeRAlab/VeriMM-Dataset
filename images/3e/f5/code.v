module gradient_descent (
    input clk,
    input reset,
    input [15:0] x_old,
    input [15:0] alpha,
    output reg [15:0] x_new
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_new <= 16'b0;
        end else begin
            x_new <= x_old - (alpha * (2 * x_old) >> 8); // Scale down for fixed point representation
        end
    end
endmodule