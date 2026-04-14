module memory_allocator(  
    input [3:0] request_size,  // Size request (0 to 15)  
    input request,              // Request signal  
    output reg [3:0] start_address, // Starting address of allocated memory  
    output reg error           // Error signal  
);  
    reg [3:0] available_memory; // Tracks available memory units  

    always @(*) begin  
        if (request) begin  
            if (request_size <= available_memory) begin  
                start_address = 16 - available_memory; // Allocate from the end of memory  
                available_memory = available_memory - request_size;  
                error = 0;  
            end else begin  
                start_address = 0;  
                error = 1; // Not enough memory  
            end  
        end else begin  
            start_address = 0;  
            error = 0; // No request made  
        end  
    end  
endmodule