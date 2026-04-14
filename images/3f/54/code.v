module chebyshev_filter(
    input wire clk,
    input wire reset,
    input wire [3:0] x,
    output reg [3:0] y
);
    reg [3:0] y_prev1, y_prev2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 4'b0000;
            y_prev1 <= 4'b0000;
            y_prev2 <= 4'b0000;
        end else begin
            y <= x + (y_prev1 >>> 1) + (y_prev2 >>> 2); // Example filter equation
            y_prev2 <= y_prev1;
            y_prev1 <= y;
        end
    end
endmodule