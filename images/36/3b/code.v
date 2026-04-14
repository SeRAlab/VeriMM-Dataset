module fir_filter (
    input wire [15:0] x0, // Input tap 0
    input wire [15:0] x1, // Input tap 1
    input wire [15:0] x2, // Input tap 2
    input wire [15:0] x3, // Input tap 3
    output wire [31:0] y   // Output
);
    // Coefficients
    reg [15:0] h0 = 16'h0001; // Coefficient for x0
    reg [15:0] h1 = 16'h0002; // Coefficient for x1
    reg [15:0] h2 = 16'h0003; // Coefficient for x2
    reg [15:0] h3 = 16'h0004; // Coefficient for x3

    // Calculate output
    assign y = (h0 * x0) + (h1 * x1) + (h2 * x2) + (h3 * x3);
endmodule