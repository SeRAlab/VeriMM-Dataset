module eeprom_cell (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg [7:0] output_data
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_data <= 8'b0;
        end else if (enable) begin
            output_data <= data_in;
        end
    end
endmodule