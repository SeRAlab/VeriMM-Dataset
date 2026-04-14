module virtual_memory_manager (
    input clk,
    input reset,
    input [1:0] virtual_address,
    input [1:0] data_in,
    input rw, // 0 for read, 1 for write
    output reg [1:0] data_out,
    output reg valid
);
    reg [1:0] page_table [0:3]; // Page table with 4 entries
    reg [1:0] physical_address;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid <= 0;
            data_out <= 2'b00;
            // Initialize page table entries to 0
            page_table[0] <= 2'b00;
            page_table[1] <= 2'b01;
            page_table[2] <= 2'b10;
            page_table[3] <= 2'b11;
        end else begin
            physical_address = page_table[virtual_address];
            if (rw) begin // write operation
                page_table[virtual_address] <= data_in;
                valid <= 1;
                data_out <= 2'b00; // No output data for write
            end else begin // read operation
                data_out <= physical_address;
                valid <= 1;
            end
        end
    end
endmodule