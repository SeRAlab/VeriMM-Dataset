module butterworth_filter (
    input [4:0] x,
    output [4:0] y
);
    wire [4:0] coeff1 = 5'b00011; // Example coefficient for first stage
    wire [4:0] coeff2 = 5'b00010; // Example coefficient for second stage
    wire [4:0] coeff3 = 5'b00001; // Example coefficient for third stage
    
    assign y = (x * coeff1 + x * coeff2 + x * coeff3) >> 2; // Example filtering logic
endmodule