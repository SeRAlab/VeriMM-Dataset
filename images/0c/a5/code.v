module sram_cell (
    input wire we,         // Write Enable
    input wire re,         // Read Enable
    input wire [7:0] data_in, // Data Input
    output reg [7:0] data_out // Data Output
);
    reg [7:0] memory; // 8-bit memory cell

    always @(posedge we) begin
        memory <= data_in; // Write data to memory
    end

    always @(posedge re) begin
        data_out <= memory; // Read data from memory
    end
endmodule