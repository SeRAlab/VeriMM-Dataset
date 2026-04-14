module sram_cell (
    input wire [15:0] data_in,
    input wire we,
    input wire re,
    output reg [15:0] data_out,
    output reg status
);
    reg [15:0] memory; // 16-bit memory storage

    always @(*) begin
        status = 0; // Default status
        if (we) begin
            memory <= data_in; // Write operation
            status = 1; // Write successful
        end else if (re) begin
            data_out <= memory; // Read operation
            status = 1; // Read successful
        end
    end
endmodule