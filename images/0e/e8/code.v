module hash_table(  
    input [4:0] key,  
    output reg [2:0] index,  
    output reg valid  
);  
    always @(*) begin  
        if (key < 32) begin  
            index = key % 8;  
            valid = 1;  
        end else begin  
            index = 3'bxxx;  
            valid = 0;  
        end  
    end  
endmodule