module SRAM_Cell (
    input wire [3:0] data_in,
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    output reg [3:0] data_out,
    output reg valid
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in;
            valid <= 1'b0; // Not valid until read
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory;
            valid <= 1'b1; // Valid data is available
        end
    end
endmodule