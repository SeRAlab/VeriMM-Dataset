module chebyshev_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] x,
    input wire [15:0] x_prev,
    output reg [15:0] y
);
    reg [15:0] a0, a1, a2; // Filter coefficients
    reg [15:0] b1, b2; // Previous outputs

    initial begin
        a0 = 16'h3F; // Example coefficient values
        a1 = 16'h7F;
        a2 = 16'h3F;
        b1 = 16'h0;
        b2 = 16'h0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 16'h0;
            b1 <= 16'h0;
            b2 <= 16'h0;
        end else begin
            y <= a0*x + a1*x_prev + b1*b1 + b2*b2; // Filter output
            b2 <= b1; // Shift previous output
            b1 <= y; // Update previous output
        end
    end
endmodule