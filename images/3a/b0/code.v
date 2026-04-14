module sram_cell (
    input [1:0] address,
    input [3:0] data_in,
    input write_enable,
    input read_enable,
    output reg [3:0] data_out
);

    reg [3:0] memory [3:0]; // 4-bit memory with 4 addresses

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory[address] <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory[address];
        end
    end
endmodule