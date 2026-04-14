module simple_hash_table(  
    input [4:0] key,  
    output [2:0] hash_value  
);  
    assign hash_value = key[2:0];  
endmodule