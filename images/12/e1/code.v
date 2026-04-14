module SRAM_Cell (
    input wire [7:0] data_in,
    input wire write_enable,
    input wire read_enable,
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Store data when write enable is asserted
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory; // Output data when read enable is asserted
        end
    end
endmodule