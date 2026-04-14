module SRAM_Cell (
    input wire clk,
    input wire we,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write to memory
        end
        data_out <= memory; // Read from memory
    end
endmodule