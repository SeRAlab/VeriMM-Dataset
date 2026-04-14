module hash_table(  
    input [4:0] key,  
    output reg [2:0] index  
);  
    always @(*) begin  
        if (key == 5) begin  
            index = 3'bxxx;  
        end else begin  
            index = key % 8;  
        end  
    end  
endmodule