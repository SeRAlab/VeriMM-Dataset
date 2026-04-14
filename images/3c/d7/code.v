module comparator_32bit (  
    input  [31:0] A,  
    input  [31:0] B,  
    output reg [1:0] result // 00: A < B, 01: A == B, 10: A > B  
);  
    always @(*) begin  
        if (A < B)  
            result = 2'b00;  
        else if (A == B)  
            result = 2'b01;  
        else  
            result = 2'b10;  
    end  
endmodule