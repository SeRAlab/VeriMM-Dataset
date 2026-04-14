module iir_filter #(parameter B0 = 16'h1, B1 = 16'h1, B2 = 16'h1, A1 = 16'h1, A2 = 16'h1) (
    input clk,
    input rst,
    input signed [15:0] x, // input signal
    output reg signed [15:0] y // output signal
);
    reg signed [15:0] w1, w2; // internal states

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'b0;
            w1 <= 16'b0;
            w2 <= 16'b0;
        end else begin
            y <= (B0 * x + B1 * w1 + B2 * w2) / A1; // Output calculation
            // Update internal states
            w2 <= w1;
            w1 <= y;
        end
    end
endmodule