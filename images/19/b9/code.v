module bilinear_interpolation(  
    input [7:0] Q11, // Value at (x1, y1)  
    input [7:0] Q21, // Value at (x2, y1)  
    input [7:0] Q12, // Value at (x1, y2)  
    input [7:0] Q22, // Value at (x2, y2)  
    input [7:0] x,    // x coordinate (between x1 and x2)  
    input [7:0] y,    // y coordinate (between y1 and y2)  
    output reg [15:0] P // Interpolated value  
);  
    wire [15:0] R1, R2;  
    wire [15:0] x1_x2;  
    wire [15:0] y1_y2;  
    wire [15:0] x2_x;  
    wire [15:0] y2_y;  

    assign x1_x2 = x - 8'd0; // Assume x1 = 0  
    assign x2_x = 8'd255 - x; // Assume x2 = 255  
    assign y1_y2 = y - 8'd0; // Assume y1 = 0  
    assign y2_y = 8'd255 - y; // Assume y2 = 255  

    assign R1 = (Q11 * x2_x + Q21 * x1_x2) >> 8;  
    assign R2 = (Q12 * x2_x + Q22 * x1_x2) >> 8;  

    always @(*) begin  
        P = (R1 * y2_y + R2 * y1_y2) >> 8;  
    end  
endmodule