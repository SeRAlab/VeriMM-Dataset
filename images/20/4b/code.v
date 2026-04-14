module matrix_inverse(  
    input [15:0] a,  
    input [15:0] b,  
    input [15:0] c,  
    input [15:0] d,  
    output reg [15:0] inv11,  
    output reg [15:0] inv12,  
    output reg [15:0] inv21,  
    output reg [15:0] inv22  
);  
    wire signed [31:0] det;  
    assign det = a * d - b * c;  
    always @(*) begin  
        if (det == 0) begin  
            inv11 = 0;  
            inv12 = 0;  
            inv21 = 0;  
            inv22 = 0;  
        end else begin  
            inv11 = d / det;  
            inv12 = -b / det;  
            inv21 = -c / det;  
            inv22 = a / det;  
        end  
    end  
endmodule