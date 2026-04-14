module memory_allocator (  
    input clk,  
    input reset,  
    input [3:0] mem_id,   // identifier for the memory block  
    input alloc,          // signal to allocate memory  
    input free,           // signal to free memory  
    output reg [3:0] status // 0: free, 1: allocated  
);  
    reg [1:0] mem_state [0:15]; // state of 16 memory blocks (0: free, 1: allocated)  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            // Initialize all memory blocks to free  
            for (i = 0; i < 16; i = i + 1) begin  
                mem_state[i] <= 2'b00;  
            end  
        end else begin  
            if (alloc) begin  
                // Allocate memory block  
                if (mem_state[mem_id] == 2'b00) begin  
                    mem_state[mem_id] <= 2'b01;  
                end  
            end  
            if (free) begin  
                // Free memory block  
                if (mem_state[mem_id] == 2'b01) begin  
                    mem_state[mem_id] <= 2'b00;  
                end  
            end  
            // Output current state of the memory block  
            status <= mem_state[mem_id];  
        end  
    end  
endmodule