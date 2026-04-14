module SRAM_Cell (
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    input wire read,
    input wire write,
    input wire clk
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write) begin
            memory <= data_in; // Write operation
        end
        if (read) begin
            data_out <= memory; // Read operation
        end
    end
endmodule