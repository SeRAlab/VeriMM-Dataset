module MemoryAllocator #(parameter MEM_SIZE = 64) (
    input clk,
    input rst,
    input [2:0] command, // 0: malloc, 1: free, 2: status
    input [5:0] addr,     // address to allocate/free
    output reg [7:0] mem_status // status of memory allocation
);

    reg [7:0] memory [0:MEM_SIZE-1];
    reg [MEM_SIZE-1:0] alloc_map;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alloc_map <= 0;
            mem_status <= 8'b0;
        end else begin
            case (command)
                3'b000: // malloc
                    if (alloc_map[addr] == 1'b0) begin
                        alloc_map[addr] <= 1'b1;
                        mem_status <= 8'b1; // allocated
                    end else begin
                        mem_status <= 8'b0; // already allocated
                    end
                3'b001: // free
                    if (alloc_map[addr] == 1'b1) begin
                        alloc_map[addr] <= 1'b0;
                        mem_status <= 8'b1; // freed
                    end else begin
                        mem_status <= 8'b0; // already freed
                    end
                3'b010: // status
                    mem_status <= alloc_map; // return current status
            endcase
        end
    end
endmodule