module memory_allocator(  
    input clk,  
    input rst,  
    input req_alloc,  
    input req_free,  
    input [3:0] block_id,  
    output reg success,  
    output reg [15:0] bitmap  
);  

    reg [15:0] mem; // Simple memory representation  
    reg [3:0] allocated_blocks;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            mem <= 16'b0;  
            bitmap <= 16'b0;  
            success <= 0;  
            allocated_blocks <= 0;  
        end else begin  
            if (req_alloc && !mem[block_id]) begin  
                mem[block_id] <= 1;  
                bitmap <= mem;  
                success <= 1;  
            end else if (req_free && mem[block_id]) begin  
                mem[block_id] <= 0;  
                bitmap <= mem;  
                success <= 1;  
            end else begin  
                success <= 0;  
            end  
        end  
    end  
endmodule