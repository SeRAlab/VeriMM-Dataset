module lms_filter (
    input clk,
    input reset,
    input signed [15:0] x, // input signal
    input signed [15:0] d, // desired signal
    output reg signed [15:0] y, // output signal
    output reg signed [15:0] e // error signal
);
    reg signed [15:0] w; // weight
    parameter signed [15:0] mu = 16'h0001; // step size

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w <= 16'h0000; // reset weight
            y <= 16'h0000; // reset output
            e <= 16'h0000; // reset error
        end else begin
            y <= w * x; // output signal
            e <= d - y; // error signal
            w <= w + (mu * e * x); // weight update
        end
    end
endmodule