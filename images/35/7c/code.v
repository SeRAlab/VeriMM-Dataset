module chebyshev_filter (
    input [3:0] x,   // Input signal
    output [3:0] y   // Output signal
);
    reg [3:0] a0 = 4'b0001; // Coefficient for x[n]
    reg [3:0] a1 = 4'b0010; // Coefficient for x[n-1]
    reg [3:0] a2 = 4'b0001; // Coefficient for x[n-2]
    
    reg [3:0] b1 = 4'b0010; // Coefficient for y[n-1]
    reg [3:0] b2 = 4'b0001; // Coefficient for y[n-2]

    reg [3:0] y_reg;
    
    always @(*) begin
        y_reg = a0 * x + a1 * (x >> 1) + a2 * (x >> 2) 
                - b1 * (y_reg >> 1) - b2 * (y_reg >> 2);
    end
    
    assign y = y_reg;
endmodule