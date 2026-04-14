module sram_cell (
    input wire write_enable,
    input wire [15:0] data_in,
    input wire read_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge write_enable) begin
        memory <= data_in;
    end

    always @(posedge read_enable) begin
        data_out <= memory;
    end
endmodule