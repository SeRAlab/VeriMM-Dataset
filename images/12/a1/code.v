module SRAM_cell (
    input wire clk,
    input wire we,          // Write Enable
    input wire [7:0] data_in,
    input wire select,      // Select for read/write
    output reg [7:0] data_out
);
    reg [7:0] memory; // 8-bit SRAM storage

    always @(posedge clk) begin
        if (we) begin
            // Write operation
            memory <= data_in;
        end
    end

    always @(posedge clk) begin
        if (!we && select) begin
            // Read operation
            data_out <= memory;
        end
    end
endmodule