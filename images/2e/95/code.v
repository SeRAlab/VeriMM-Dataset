module iir_filter #(
    parameter B0 = 16'h0A00, // Example coefficient
    parameter B1 = 16'h0A00, // Example coefficient
    parameter B2 = 16'h0A00, // Example coefficient
    parameter A1 = 16'hFFFF, // Example coefficient (should be less than 1, in Q format)
    parameter A2 = 16'hFFFF  // Example coefficient (should be less than 1, in Q format)
)(
    input clk,
    input rst,
    input signed [15:0] x, // Input sample
    output reg signed [15:0] y  // Output sample
);

    reg signed [15:0] delay1, delay2; // Delay elements for feedback

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0000;
            delay1 <= 16'h0000;
            delay2 <= 16'h0000;
        end else begin
            y <= B0 * x + B1 * delay1 + B2 * delay2 - A1 * y - A2 * delay2;
            delay2 <= delay1;
            delay1 <= x;
        end
    end
endmodule