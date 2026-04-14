module sram_cell (
    input wire [15:0] data_in,
    input wire we,
    input wire clk,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in;  // Write data to memory
        end
        data_out <= memory;    // Output data from memory
    end
endmodule