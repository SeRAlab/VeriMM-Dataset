module DRAM_16bit (
    input wire [15:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge write_enable) begin
        memory <= data_in; // Store data when write_enable is high
    end

    always @(posedge read_enable) begin
        data_out <= memory; // Output data when read_enable is high
    end
endmodule