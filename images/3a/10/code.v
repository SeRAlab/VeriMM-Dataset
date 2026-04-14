module SRAM_Cell (
    input [7:0] data_in,
    input [2:0] address,
    input write_enable,
    input read_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8 cells, 8 bits each

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to the specified address
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory[address]; // Read data from the specified address
        end
    end
endmodule