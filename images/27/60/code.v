module fir_filter (
    input [4:0] x, // Input signal
    input [4:0] coeff0, // Coefficient for tap 0
    input [4:0] coeff1, // Coefficient for tap 1
    input [4:0] coeff2, // Coefficient for tap 2
    input [4:0] coeff3, // Coefficient for tap 3
    input [4:0] coeff4, // Coefficient for tap 4
    output reg [9:0] y // Output result
);
    
    always @(*) begin
        y = (x * coeff0) + (x * coeff1) + (x * coeff2) + (x * coeff3) + (x * coeff4);
    end
endmodule