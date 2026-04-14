module eeprom_cell (
    input wire clk,
    input wire enable,
    input wire write,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0; // Reset data
        end else if (enable) begin
            if (write) begin
                data_out <= data_in; // Write data
            end
        end
    end
endmodule