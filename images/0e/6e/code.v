module memory_manager (
    input clk,
    input rst,
    input alloc,        // Allocate signal
    input free,         // Free signal
    output reg [3:0] memory_status // Status of memory blocks
);
    reg [3:0] alloc_status; // To track allocated blocks

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            alloc_status <= 4'b0000; // All blocks free on reset
            memory_status <= 4'b0000;
        end else begin
            if (alloc) begin
                // Allocate memory if there's free space
                if (alloc_status < 4'b1111) begin
                    alloc_status <= alloc_status + 1; // Increment allocated blocks
                end
            end

            if (free) begin
                // Free the last allocated block
                if (alloc_status > 0) begin
                    alloc_status <= alloc_status - 1; // Decrement allocated blocks
                end
            end

            memory_status <= alloc_status; // Update memory status output
        end
    end
endmodule