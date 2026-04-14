module memory_allocator (  
    input clk,  
    input reset,  
    input [2:0] request,  // request: 3-bit address for allocate/free  
    input allocate,       // 1 for malloc, 0 for free  
    output reg success,   // 1 if operation successful  
    output reg [7:0] memory_status // 8-bit status of memory blocks  
);  
    reg [7:0] memory;  // 8 memory blocks, 1 bit each  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            memory <= 8'b00000000; // initialize memory to free  
            success <= 0;  
            memory_status <= memory;  
        end else begin  
            if (allocate) begin  // malloc operation  
                if (memory[request] == 0) begin  
                    memory[request] <= 1; // allocate memory  
                    success <= 1;  
                end else begin  
                    success <= 0; // already allocated  
                end  
            end else begin  // free operation  
                if (memory[request] == 1) begin  
                    memory[request] <= 0; // free memory  
                    success <= 1;  
                end else begin  
                    success <= 0; // already free  
                end  
            end  
            memory_status <= memory;  
        end  
    end  
endmodule