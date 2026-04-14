module memory_manager (
    input clk,
    input rst,
    input [9:0] allocate_size, // size in bytes
    input [9:0] free_address,   // address to free
    input alloc,                // allocate signal
    input free,                 // free signal
    output reg [10:0] used_memory, // number of bytes currently used
    output reg [10:0] free_memory  // number of bytes currently free
);
    reg [1023:0] memory; // 1024 bytes of memory
    initial begin
        used_memory = 0;
        free_memory = 1024;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            used_memory <= 0;
            free_memory <= 1024;
            memory <= 0; // reset memory
        end else begin
            if (alloc) begin
                if (allocate_size <= free_memory) begin
                    used_memory <= used_memory + allocate_size;
                    free_memory <= free_memory - allocate_size;
                end
            end
            if (free) begin
                if (free_address < used_memory) begin
                    used_memory <= used_memory - allocate_size; // assume size is known
                    free_memory <= free_memory + allocate_size;
                end
            end
        end
    end
endmodule