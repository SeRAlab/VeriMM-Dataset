module SRAM_Cell (
    input wire [3:0] data_in,
    input wire write_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory; // 4-bit memory cell

    always @(posedge write_enable) begin
        memory <= data_in; // Writing data to memory
    end

    always @(*) begin
        if (!write_enable) begin
            data_out <= memory; // Reading data from memory
        end
    end
endmodule