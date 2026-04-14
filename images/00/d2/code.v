module multiplier_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    output reg [63:0] P  
);  
    always @* begin  
        P = A * B;  
    end  
endmodule