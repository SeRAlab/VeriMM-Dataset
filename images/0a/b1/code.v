module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg cell_data;

    always @(posedge write_enable) begin
        cell_data <= data_in;
    end

    always @(posedge read_enable) begin
        data_out <= cell_data;
    end
endmodule