module hash_table (  
    input [7:0] key,  
    output [3:0] index  
);  
    assign index = key % 16;  
endmodule