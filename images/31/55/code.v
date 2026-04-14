module sram_cell (
    input wire write_enable,
    input wire data_in,
    output reg data_out
);
    always @(posedge write_enable) begin
        data_out <= data_in; // Store the data when write_enable is high
    end
endmodule