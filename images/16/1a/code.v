module eeprom_cell (
    input wire clk,
    input wire [1:0] control,
    input wire data_in,
    output reg data_out
);
    reg stored_value;

    always @(posedge clk) begin
        case (control)
            2'b00: begin
                // Read operation
                data_out <= stored_value;
            end
            2'b01: begin
                // Write operation
                stored_value <= data_in;
            end
            2'b10: begin
                // Erase operation
                stored_value <= 1'b0;
            end
            default: begin
                // Do nothing
            end
        endcase
    end
endmodule