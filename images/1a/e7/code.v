module IIR_Filter (
    input clk,
    input reset,
    input signed [15:0] X,  // Input Sample
    output reg signed [15:0] Y  // Output Sample
);
    reg signed [15:0] Y_prev;  // Previous Output Sample

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Y <= 0;
            Y_prev <= 0;
        end else begin
            Y <= 0.5 * X + 0.25 * Y_prev;  // IIR Filter equation
            Y_prev <= Y;  // Update previous output
        end
    end
endmodule