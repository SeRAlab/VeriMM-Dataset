module bilinear_interpolation (  
    input [7:0] P00,  
    input [7:0] P01,  
    input [7:0] P10,  
    input [7:0] P11,  
    input [7:0] x_frac,  
    input [7:0] y_frac,  
    output [7:0] P_out  
);  
    wire [15:0] P_top, P_bottom;  
    wire [15:0] P_top_left, P_top_right, P_bottom_left, P_bottom_right;  
    wire [15:0] x_weight, y_weight;  
    assign x_weight = (256 - x_frac);  
    assign y_weight = (256 - y_frac);  

    // Weighted contributions of each pixel  
    assign P_top_left = P00 * x_weight * y_weight;  
    assign P_top_right = P01 * x_frac * y_weight;  
    assign P_bottom_left = P10 * x_weight * y_frac;  
    assign P_bottom_right = P11 * x_frac * y_frac;  

    // Sum contributions  
    assign P_top = P_top_left + P_top_right;  
    assign P_bottom = P_bottom_left + P_bottom_right;  

    // Final output normalized to 8-bit  
    assign P_out = (P_top + P_bottom) >> 16;  

endmodule