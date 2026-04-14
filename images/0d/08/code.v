module SRAM_Cell (
    input wire [15:0] data_in,
    input wire write_enable,
    input wire read_enable,
    input wire reset,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge reset or posedge write_enable) begin
        if (reset) begin
            memory <= 16'b0;
        end else if (write_enable) begin
            memory <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory;
        end
    end
endmodule