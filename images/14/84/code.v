module SRAM_Cell (
    input [7:0] data_in,
    input read_enable,
    input write_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory; // Internal storage for SRAM

    always @(posedge write_enable) begin
        memory <= data_in; // Write data to memory
    end

    always @(posedge read_enable) begin
        data_out <= memory; // Read data from memory
    end
endmodule