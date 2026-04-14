module memory_allocator #(parameter MAX_SIZE = 32) (  
    input clk,  
    input reset,  
    input [4:0] request_size,  // request size for allocation  
    input allocate,             // signal to allocate memory  
    input deallocate,           // signal to free memory  
    output reg [4:0] allocated_size, // size of the allocated block  
    output reg success          // flag for successful allocation/freeing  
);  
    reg [4:0] allocated;  
    initial begin  
        allocated = 0;  
        allocated_size = 0;  
        success = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            allocated <= 0;  
            allocated_size <= 0;  
            success <= 0;  
        end else if (allocate) begin  
            if (allocated + request_size <= MAX_SIZE) begin  
                allocated <= allocated + request_size;  
                allocated_size <= request_size;  
                success <= 1;  
            end else begin  
                allocated_size <= 0;  
                success <= 0;  
            end  
        end else if (deallocate) begin  
            if (allocated >= request_size) begin  
                allocated <= allocated - request_size;  
                allocated_size <= request_size;  
                success <= 1;  
            end else begin  
                allocated_size <= 0;  
                success <= 0;  
            end  
        end  
    end  
endmodule