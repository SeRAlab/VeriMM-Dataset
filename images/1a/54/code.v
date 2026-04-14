module hash_table(  
    input [4:0] addr,  
    output reg [2:0] data  
);  

    reg [2:0] memory [0:31]; // 32 addresses with 3-bit data  

    initial begin  
        // Initialize the hash table with some values  
        memory[0] = 3'b101;  
        memory[1] = 3'b010;  
        memory[2] = 3'b110;  
        memory[3] = 3'b001;  
        memory[4] = 3'b111;  
        // All other addresses default to 3'b000  
    end  

    always @* begin  
        data = memory[addr];  
    end  

endmodule