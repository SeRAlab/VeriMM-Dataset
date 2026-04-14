module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    input wire row_address,
    output reg data_out
);
    reg stored_value;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_value <= data_in;
        end
        if (read_enable) begin
            data_out <= stored_value;
        end
    end
endmodule