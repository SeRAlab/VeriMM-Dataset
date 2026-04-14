module sram_cell (
    input [3:0] data_in,
    input write_enable,
    input read_enable,
    output reg [3:0] data_out
);
    reg [3:0] storage;

    always @(posedge write_enable) begin
        storage <= data_in;
    end

    always @(posedge read_enable) begin
        data_out <= storage;
    end
endmodule