module matrix_inverse(  
    input [7:0] a,  
    input [7:0] b,  
    input [7:0] c,  
    input [7:0] d,  
    output reg [7:0] inv_a,  
    output reg [7:0] inv_b,  
    output reg [7:0] inv_c,  
    output reg [7:0] inv_d  
);  
    reg [15:0] det;  

    always @(*) begin  
        // Calculate the determinant  
        det = a * d - b * c;  
          
        if (det == 0) begin  
            // Not invertible, output zeros  
            inv_a = 8'b0;  
            inv_b = 8'b0;  
            inv_c = 8'b0;  
            inv_d = 8'b0;  
        end else begin  
            // Calculate the inverse matrix  
            inv_a = d / det;  
            inv_b = -b / det;  
            inv_c = -c / det;  
            inv_d = a / det;  
        end  
    end  
endmodule