module matrix_inverse_2x2 (  
    input [15:0] a11, a12,  
    input [15:0] a21, a22,  
    output reg [15:0] inv11, inv12,  
    output reg [15:0] inv21, inv22  
);  
    reg signed [31:0] det;  
    always @* begin  
        det = a11 * a22 - a12 * a21;  
        if (det != 0) begin  
            inv11 = a22 / det;  
            inv12 = -a12 / det;  
            inv21 = -a21 / det;  
            inv22 = a11 / det;  
        end else begin  
            inv11 = 16'hFFFF;  
            inv12 = 16'hFFFF;  
            inv21 = 16'hFFFF;  
            inv22 = 16'hFFFF;  
        end  
    end  
endmodule