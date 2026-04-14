module top_module(
    input clk,
    input [15:0] data_in,
    input [10:0] write_addr,
    input write_en,
    input [10:0] read_addr,
    input read_en,
    output reg [15:0] data_out
);// Declare RAM storage
    reg [15:0] ram [0:2047]; // 2^11 = 2048 words of depth, 16 bits wide

    always @(posedge clk) begin
        if (write_en) begin
            ram[write_addr] <= data_in; // Write data to RAM
        end
        if (read_en) begin
            data_out <= ram[read_addr];  // Read data from RAM
        end
    end

endmodule