module eeprom_cell (
    input wire clk,
    input wire reset,
    input wire we,
    input wire re,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 1'b0;
        end else if (we) begin
            data_out <= data_in;
        end
    end
endmodule