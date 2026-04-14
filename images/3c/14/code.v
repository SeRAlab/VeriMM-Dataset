module memory_allocator #(parameter N = 8) (
    input wire clk,
    input wire rst,
    input wire [2:0] cmd, // 0: malloc, 1: free, 2: status
    input wire [2:0] index, // index for malloc/free
    output reg [N-1:0] mem_status // memory status output
);
    reg [N-1:0] mem_array;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            mem_array <= {N{1'b0}}; // Initialize all blocks to free (0)
            mem_status <= {N{1'b0}};
        end else begin
            case (cmd)
                3'b000: begin // malloc
                    if (index < N && mem_array[index] == 1'b0) begin
                        mem_array[index] <= 1'b1; // Allocate the block
                    end
                end
                3'b001: begin // free
                    if (index < N) begin
                        mem_array[index] <= 1'b0; // Deallocate the block
                    end
                end
                3'b010: begin // status
                    mem_status <= mem_array; // Output the memory status
                end
                default: begin
                    mem_status <= mem_status; // No action
                end
            endcase
        end
    end
endmodule