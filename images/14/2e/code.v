module adaptive_lms_filter(
    input clk,
    input reset,
    input [15:0] x, // input signal
    input [15:0] d, // desired signal
    output reg [15:0] y, // output signal
    output reg [15:0] coef0, // coefficient for tap 0
    output reg [15:0] coef1  // coefficient for tap 1
);
    reg [15:0] error;
    reg [15:0] y_temp;

    parameter mu = 16'h0001; // step size

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            coef0 <= 16'h0000;
            coef1 <= 16'h0000;
            y <= 16'h0000;
        end else begin
            // Calculate output
            y_temp = (coef0 * x) + (coef1 * x);
            y <= y_temp;

            // Calculate error
            error = d - y_temp;

            // Update coefficients
            coef0 <= coef0 + (mu * error * x);
            coef1 <= coef1 + (mu * error * x);
        end
    end
endmodule