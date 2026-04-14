module sram_cell (
    input [7:0] data_in,
    input write_enable,
    input read_enable,
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