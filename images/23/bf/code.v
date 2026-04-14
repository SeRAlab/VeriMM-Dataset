module SRAM_Cell (
    input wire [7:0] data_in,
    input wire enable,
    input wire write,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge enable) begin
        if (write) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Read data from memory
    end
endmodule