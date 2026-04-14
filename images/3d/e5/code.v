module sram_cell (
    input wire [7:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(*) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
        if (read_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule