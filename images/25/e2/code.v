module sobel_edge_detection (
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output reg [9:0] gradient_magnitude
);
    
    integer Gx, Gy;
    
    always @(*) begin
        // Calculate Gx
        Gx = (pixel00 + 2*pixel01 + pixel02) - (pixel20 + 2*pixel21 + pixel22);
        // Calculate Gy
        Gy = (pixel00 + 2*pixel10 + pixel20) - (pixel02 + 2*pixel12 + pixel22);
        
        // Calculate gradient magnitude
        gradient_magnitude = Gx * Gx + Gy * Gy; // Use square for better precision
    end
endmodule