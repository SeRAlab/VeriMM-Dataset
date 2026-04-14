module eeprom_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire erase,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] stored_data;

    always @(posedge clk) begin
        if (erase) begin
            stored_data <= 5'b00000; // Erase data
        end else if (write_enable) begin
            stored_data <= data_in; // Write data
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_data; // Read data
        end
    end
endmodule