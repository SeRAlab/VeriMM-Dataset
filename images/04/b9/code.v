module sram_cell (
    input wire [15:0] data_in,
    input wire we,
    input wire re,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge we) begin
        memory <= data_in; // Write data to memory
    end

    always @(posedge re) begin
        data_out <= memory; // Read data from memory
    end
endmodule