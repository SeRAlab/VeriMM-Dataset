module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg stored_data;

    always @(*) begin
        if (write_enable) begin
            stored_data <= data_in;
        end
        if (read_enable) begin
            data_out <= stored_data;
        end
    end
endmodule