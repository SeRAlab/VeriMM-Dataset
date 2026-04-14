module memory_allocator(  
    input wire [2:0] req, // Request size (1 to 7) bytes  
    input wire free,      // Free memory request  
    output reg alloc_success // Allocation success  
);  
    reg [7:0] memory; // 8 bytes of memory  
    initial begin  
        memory = 8'b00000000; // Initialize memory to 0 (free)  
    end  

    always @(*) begin  
        if (free) begin  
            // Free memory: set all bits to 0  
            memory = 8'b00000000;  
            alloc_success = 1;  
        end else if (req > 0 && req <= 7 && (memory & (8'hFF >> (8 - req))) == 0) begin  
            // Allocate memory if requested size is free  
            memory = memory | (8'hFF >> (8 - req));  
            alloc_success = 1;  
        end else begin  
            alloc_success = 0; // Allocation failed  
        end  
    end  
endmodule