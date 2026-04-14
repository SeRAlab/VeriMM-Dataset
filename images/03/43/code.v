module sram_cell (
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    output reg data_out
);
    reg memory;

    always @(posedge write_enable) begin
        memory <= data_in;
    end

    always @(posedge read_enable) begin
        data_out <= memory;
    end
endmodule