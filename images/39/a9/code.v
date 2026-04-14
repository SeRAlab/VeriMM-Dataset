module memory_allocator(  
    input clk,  
    input reset,  
    input [3:0] req_type,  // 0: malloc, 1: free  
    input [7:0] size,      // size of memory block to allocate  
    output reg success,     // indicates success of the request  
    output reg [7:0] alloc_address // address of allocated memory  
);  
    parameter MEMORY_SIZE = 256;  
    reg [7:0] memory [0:MEMORY_SIZE-1];  
    reg [7:0] free_list [0:MEMORY_SIZE-1];  
    reg [7:0] free_count;  
    integer i;  

    initial begin  
        free_count = MEMORY_SIZE;  
        for (i = 0; i < MEMORY_SIZE; i = i + 1) begin  
            free_list[i] = i;  
        end  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            success <= 0;  
            alloc_address <= 0;  
            free_count <= MEMORY_SIZE;  
        end else begin  
            if (req_type == 0) begin  // malloc  
                if (free_count >= size) begin  
                    alloc_address <= free_list[free_count - 1];  
                    free_count <= free_count - size;  
                    success <= 1;  
                end else begin  
                    success <= 0;  
                end  
            end else if (req_type == 1) begin  // free  
                free_count <= free_count + size;  
                success <= 1;  
            end  
        end  
    end  
endmodule