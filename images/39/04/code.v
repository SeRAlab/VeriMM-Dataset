module dram_4bit (
    input clk,
    input [1:0] addr,  // 2-bit address for 4 bits
    input [3:0] write_data,  // 4-bit input data
    input write_enable,  // Write enable signal
    input read_enable,   // Read enable signal
    output reg [3:0] read_data  // 4-bit output data
);

    reg [3:0] memory [0:3];  // 4-bit memory array with 4 locations

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= write_data;  // Write data to memory
        end
        if (read_enable) begin
            read_data <= memory[addr];  // Read data from memory
        end
    end
endmodule