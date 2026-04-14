module sram_cell (
    input wire [3:0] data_in,
    input wire we,        // Write enable
    input wire sel,       // Select signal
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge we) begin
        memory <= data_in; // Write data on the positive edge of write enable
    end

    always @(posedge sel) begin
        data_out <= memory; // Output data on the positive edge of select
    end
endmodule