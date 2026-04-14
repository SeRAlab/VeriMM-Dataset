module fir_filter (
    input [3:0] x0, // current input
    input [3:0] x1, // previous input
    input [3:0] x2, // second previous input
    input [3:0] x3, // third previous input
    output reg [7:0] y  // output
);

always @(*) begin
    y = (1*x0) + (2*x1) + (3*x2) + (4*x3); // FIR filter calculation
end

endmodule