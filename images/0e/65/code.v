module neural_neuron (
    input wire clk,
    input wire enable,
    input wire [3:0] x1, x2, x3, x4, x5, // 4-bit inputs
    input wire [3:0] w1, w2, w3, w4, w5, // 4-bit weights
    input wire [3:0] b,                  // 4-bit bias
    input wire [3:0] threshold,           // 4-bit threshold
    output reg y                          // output
);
    reg [7:0] weighted_sum; // 8-bit to hold the sum

    always @(posedge clk) begin
        if (enable) begin
            weighted_sum = (x1 * w1) + (x2 * w2) + (x3 * w3) + (x4 * w4) + (x5 * w5) + b;
            if (weighted_sum > threshold)
                y <= 1;
            else
                y <= 0;
        end
    end
endmodule