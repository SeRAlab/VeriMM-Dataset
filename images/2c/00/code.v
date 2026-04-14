module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    reg stored_value;

    always @(posedge write_enable) begin
        if (write_enable) begin
            stored_value <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= stored_value;
        end
    end
endmodule