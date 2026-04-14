module bilinear_interpolation(  
    input [7:0] p00,  
    input [7:0] p01,  
    input [7:0] p10,  
    input [7:0] p11,  
    input [3:0] x_fraction,  
    input [3:0] y_fraction,  
    output reg [7:0] p_out  
);  
    wire [15:0] p0, p1;  
    wire [15:0] p0_weighted, p1_weighted;  
  
    // Calculate the weighted values  
    assign p0 = (p00 * (16'h100 - x_fraction)) + (p01 * x_fraction);  
    assign p1 = (p10 * (16'h100 - x_fraction)) + (p11 * x_fraction);  
    assign p0_weighted = p0 * (16'h100 - y_fraction);  
    assign p1_weighted = p1 * y_fraction;  
  
    // Combine to get interpolated value  
    always @(*) begin  
        p_out = (p0_weighted + p1_weighted) >> 8;  
    end  
endmodule