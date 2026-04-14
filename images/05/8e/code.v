module eeprom_cell (
    input wire clk,
    input wire write_en,
    input wire read_en,
    input wire erase_en,
    input wire data_in,
    output reg data_out
);

    always @(posedge clk) begin
        if (erase_en) begin
            data_out <= 1'b0;
        end else if (write_en) begin
            data_out <= data_in;
        end else if (read_en) begin
            // data_out is updated on read; no action needed here
        end
    end
endmodule