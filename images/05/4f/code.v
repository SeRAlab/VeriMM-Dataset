module EEPROM_Cell (
    input wire clk,
    input wire enable,
    input wire write_data,
    output reg stored_data
);
    
    always @(posedge clk) begin
        if (enable) begin
            stored_data <= write_data;  // Write operation
        end
    end

endmodule