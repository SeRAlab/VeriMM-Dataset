module adaptive_lms_filter (
    input clk,
    input reset,
    input [15:0] x,        // input signal
    input [15:0] d,        // desired signal
    output reg [15:0] y,   // output signal
    output reg [15:0] w0,  // weight
    output reg [15:0] e     // error signal
);
    parameter mu = 16'h0001; // step size
    reg [15:0] x_delayed;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w0 <= 16'h0000;
            y <= 16'h0000;
            e <= 16'h0000;
            x_delayed <= 16'h0000;
        end else begin
            x_delayed <= x;
            y <= w0 * x_delayed; // Output of the filter
            e <= d - y;           // Error signal
            w0 <= w0 + (mu * e * x_delayed); // Weight update
        end
    end
endmodule