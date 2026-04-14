module dram_4bit(
    input [3:0] data_in,
    input write_enable,
    input [1:0] row_address,
    input [1:0] column_address,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3][0:3]; // 4x4 memory array

    always @(posedge write_enable) begin
        memory[row_address][column_address] <= data_in; // Write data to memory
    end

    always @(*) begin
        data_out <= memory[row_address][column_address]; // Read data from memory
    end
endmodule