module fir_filter (
    input [2:0] x,         // Current input
    input [2:0] x1,        // Previous input
    input [2:0] x2,        // Two previous input
    output reg [2:0] y     // Output
);
    always @(*) begin
        y = x + x1 + x2;    // FIR filter calculation
    end
endmodule