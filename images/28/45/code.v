module rnn_inference (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] x0,
    input wire [7:0] x1,
    input wire [7:0] x2,
    input wire [7:0] x3,
    output reg [7:0] y,
    output reg valid
);
    reg [7:0] state;
    reg [7:0] w[0:3]; // weights for each input
    integer i;

    initial begin
        // Initialize weights (example values)
        w[0] = 8'h1; // Weight for x0
        w[1] = 8'h2; // Weight for x1
        w[2] = 8'h3; // Weight for x2
        w[3] = 8'h4; // Weight for x3
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'h00;
            valid <= 0;
        end else if (enable) begin
            // Simple RNN update rule: state = tanh(w0*x0 + w1*x1 + w2*x2 + w3*x3)
            state = (w[0] * x0 + w[1] * x1 + w[2] * x2 + w[3] * x3) >> 2; // simple scaling
            y <= state; // output the state
            valid <= 1; // signal that output is valid
        end
    end
endmodule