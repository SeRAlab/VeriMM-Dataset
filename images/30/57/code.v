module comparator_64bit(  
    input [63:0] A,  
    input [63:0] B,  
    output reg [2:0] result  
);  
    always @* begin  
        if (A < B)  
            result = 3'b001;  
        else if (A == B)  
            result = 3'b010;  
        else  
            result = 3'b100;  
    end  
endmodule