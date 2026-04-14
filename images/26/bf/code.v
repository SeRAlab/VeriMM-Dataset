module matrix_inverse(input [31:0] a11, a12, a21, a22,  
                      output reg [31:0] inv11, inv12, inv21, inv22);  
    reg [63:0] det;  
    always @(*) begin  
        det = a11 * a22 - a12 * a21;  
        if (det != 0) begin  
            inv11 = a22 / det;  
            inv12 = -a12 / det;  
            inv21 = -a21 / det;  
            inv22 = a11 / det;  
        end else begin  
            inv11 = 0;  
            inv12 = 0;  
            inv21 = 0;  
            inv22 = 0;  
        end  
    end  
endmodule