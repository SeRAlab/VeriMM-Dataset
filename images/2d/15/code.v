module EEPROM_Cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stored_data;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_data <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_data;
        end
    end
endmodule