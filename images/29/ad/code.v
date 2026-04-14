module SRAM_4bit (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(*) begin
        if (write_enable) begin
            memory <= data_in;
        end
    end

    always @(*) begin
        if (read_enable) begin
            data_out <= memory;
        end
    end
endmodule