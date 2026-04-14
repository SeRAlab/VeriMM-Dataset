module lms_filter #(parameter TAPS = 8, parameter DATA_WIDTH = 16)(
    input clk,
    input rst,
    input signed [DATA_WIDTH-1:0] x,      // input signal
    input signed [DATA_WIDTH-1:0] d,      // desired signal
    output signed [DATA_WIDTH-1:0] y      // output signal
);
    reg signed [DATA_WIDTH-1:0] w [0:TAPS-1]; // coefficients
    reg signed [DATA_WIDTH-1:0] y_reg;         // output register
    reg signed [DATA_WIDTH-1:0] e;             // error
    reg [4:0] i;                               // loop counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize weights to zero
            for (i = 0; i < TAPS; i = i + 1)
                w[i] <= 0;
            y_reg <= 0;
        end else begin
            e <= d - y_reg; // Calculate error
            // Update weights using LMS algorithm
            for (i = 0; i < TAPS; i = i + 1) begin
                w[i] <= w[i] + (e * x) >> 4; // adaptation step
            end
            // Calculate output
            y_reg <= 0;
            for (i = 0; i < TAPS; i = i + 1) begin
                y_reg <= y_reg + (w[i] * x);
            end
        end
    end

    assign y = y_reg;
endmodule