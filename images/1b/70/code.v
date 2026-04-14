module ecc_point_addition (  
    input clk,  
    input rst,  
    input [31:0] x1,  
    input [31:0] y1,  
    input [31:0] x2,  
    input [31:0] y2,  
    output reg [31:0] x3,  
    output reg [31:0] y3  
);  
    parameter a = 3;  
    parameter b = 7;  
    reg [31:0] lambda;  
    reg [31:0] x_temp;  
    reg [31:0] y_temp;  
      
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x3 <= 32'b0;  
            y3 <= 32'b0;  
        end else begin  
            if (x1 == x2 && y1 == y2) begin  
                // Point doubling  
                lambda <= (3 * x1 * x1 + a) / (2 * y1);  
                x_temp <= (lambda * lambda - 2 * x1) % 101; // mod 101 for finite field  
                y_temp <= (lambda * (x1 - x_temp) - y1) % 101;  
            end else if (x1 == x2 && y1 != y2) begin  
                // Point at infinity  
                x3 <= 32'b0;  
                y3 <= 32'b0;  
            end else begin  
                // Point addition  
                lambda <= (y2 - y1) / (x2 - x1);  
                x_temp <= (lambda * lambda - x1 - x2) % 101;  
                y_temp <= (lambda * (x1 - x_temp) - y1) % 101;  
            end  
            x3 <= x_temp;  
            y3 <= y_temp;  
        end  
    end  
endmodule