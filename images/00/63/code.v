module eeprom_cell(
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    output reg data_out
);

    reg stored_bit;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_bit <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_bit;
        end
    end
endmodule