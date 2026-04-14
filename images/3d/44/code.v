module eeprom_controller (
    input clk,
    input reset,
    input rw, // 1 for Write, 0 for Read
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;
    reg writing;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 4'b0000;
            data_out <= 4'b0000;
            writing <= 1'b0;
        end else begin
            if (rw) begin // Write operation
                memory <= data_in;
                writing <= 1'b1;
            end else begin // Read operation
                data_out <= memory;
                writing <= 1'b0;
            end
        end
    end

    // Erase operation
    always @(posedge clk) begin
        if (!rw && !writing) begin // Only erase when not writing and reading is complete
            memory <= 4'b0000;
        end
    end
endmodule