module eeprom_cell (
    input wire clk,
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_data <= data_in; // Store the input data
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_data; // Output the stored data
        end
    end
endmodule