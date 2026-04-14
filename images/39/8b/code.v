module binary_search_comparator(  
    input [4:0] A,  
    input [4:0] B,  
    output reg [1:0] result  
);  
    always @(*) begin  
        if (A > B)  
            result = 2'b01; // A > B  
        else if (A == B)  
            result = 2'b00; // A == B  
        else  
            result = 2'b11; // A < B  
    end  
endmodule