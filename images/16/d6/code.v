module DRAM_Cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write operation
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory; // Read operation
        end
    end
endmodule