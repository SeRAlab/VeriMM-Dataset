module eeprom_cell (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 1'b0; // Reset the stored bit to 0
        end else if (write_enable) begin
            data_out <= data_in; // Write the input data
        end
    end
endmodule