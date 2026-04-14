module SRAM_Cell (
    input wire [15:0] data_in,
    input wire enable,
    input wire write,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge enable) begin
        if (write) begin
            memory <= data_in;
        end else begin
            data_out <= memory;
        end
    end
endmodule