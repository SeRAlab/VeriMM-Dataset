module adaptive_lms_filter (
    input clk,
    input reset,
    input [15:0] x,         // input signal
    input [15:0] d,         // desired signal
    input [15:0] mu,        // step size (adaptation factor)
    output reg [15:0] y      // output signal
);
    reg [15:0] w0, w1;      // filter coefficients
    reg [15:0] e;           // error signal

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w0 <= 16'b0;
            w1 <= 16'b0;
            y <= 16'b0;
        end else begin
            // Calculate output
            y <= (w0 * x) + (w1 * x); 
            // Calculate error
            e <= d - y; 
            // Update coefficients
            w0 <= w0 + (mu * e * x);
            w1 <= w1 + (mu * e * x);
        end
    end
endmodule