module IIR_Filter (
    input clk,
    input reset,
    input [7:0] x,  // Input data
    output reg [7:0] y  // Output data
);
    parameter a = 8'h1;  // Coefficient a
    parameter b = 8'h1;  // Coefficient b
    reg [7:0] y_prev;  // Previous output storage

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            y <= 8'b0;  // Reset output
            y_prev <= 8'b0;  // Reset previous output
        end else begin
            y <= (a * x + b * y_prev) >> 8;  // IIR filter equation
            y_prev <= y;  // Store previous output
        end
    end
endmodule