module SRAM_Cell (
    input wire [7:0] data_in,
    input wire we, // Write Enable
    input wire clk,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Read data from memory
    end
endmodule