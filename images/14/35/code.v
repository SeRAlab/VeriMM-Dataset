module matrix_inverse (  
    input [15:0] a,  
    input [15:0] b,  
    input [15:0] c,  
    input [15:0] d,  
    output reg [15:0] out11,  
    output reg [15:0] out12,  
    output reg [15:0] out21,  
    output reg [15:0] out22  
);  
    wire signed [31:0] det;  
    assign det = a * d - b * c;  

    always @(*) begin  
        if (det != 0) begin  
            out11 = d / det;  
            out12 = -b / det;  
            out21 = -c / det;  
            out22 = a / det;  
        end else begin  
            out11 = 16'hFFFF; // Indicating no inverse  
            out12 = 16'hFFFF;  
            out21 = 16'hFFFF;  
            out22 = 16'hFFFF;  
        end  
    end  
endmodule