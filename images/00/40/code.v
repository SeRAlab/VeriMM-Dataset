module sram_cell (
    input wire [7:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory;
        end
    end
endmodule