module SRAM_4bit (
    input wire clk,
    input wire we, // write enable
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data
        end
        data_out <= memory; // Read data
    end
endmodule