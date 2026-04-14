module virtual_memory_management (
    input clk,
    input reset,
    input [3:0] page_number,
    output reg hit,
    output reg miss
);
    reg [3:0] memory [0:3]; // Memory can hold 4 pages (0-3)
    integer i;
    reg page_exists;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize memory to default pages
            memory[0] <= 4'b0000;
            memory[1] <= 4'b0001;
            memory[2] <= 4'b0010;
            memory[3] <= 4'b0011;
            hit <= 0;
            miss <= 0;
        end else begin
            page_exists = 0;
            // Check if the page exists in memory
            for (i = 0; i < 4; i = i + 1) begin
                if (memory[i] == page_number) begin
                    page_exists = 1;
                end
            end
            if (page_exists) begin
                hit <= 1;
                miss <= 0;
            end else begin
                hit <= 0;
                miss <= 1;
                // Shift the memory and add the new page
                memory[0] <= memory[1];
                memory[1] <= memory[2];
                memory[2] <= memory[3];
                memory[3] <= page_number;
            end
        end
    end
endmodule