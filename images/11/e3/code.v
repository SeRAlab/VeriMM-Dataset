module sram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    input wire clk,
    input wire reset,
    output reg data_out
);

    reg stored_value;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_value <= 1'b0;
            data_out <= 1'b0;
        end else if (write_enable) begin
            stored_value <= data_in;
        end else if (read_enable) begin
            data_out <= stored_value;
        end
    end
endmodule