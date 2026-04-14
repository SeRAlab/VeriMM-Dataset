module fir_filter (
    input wire clk,
    input wire [7:0] x,  // 8-bit input sample
    output reg [7:0] y   // 8-bit output sample
);
    parameter [7:0] h0 = 8'h01, h1 = 8'h02, h2 = 8'h03, h3 = 8'h04;
    parameter [7:0] h4 = 8'h05, h5 = 8'h06, h6 = 8'h07, h7 = 8'h08; // Filter coefficients
    reg [15:0] accum;  // Accumulator for the filter output

    always @(*) begin
        accum = (h0 * x) + (h1 * x) + (h2 * x) + (h3 * x) +
                (h4 * x) + (h5 * x) + (h6 * x) + (h7 * x);
        y = accum[7:0]; // Output the lower 8 bits of the accumulated value
    end
endmodule