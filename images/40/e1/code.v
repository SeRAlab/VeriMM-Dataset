module eeprom (
    input clk,
    input [3:0] data_in,
    input control, // 1 for write, 0 for read
    output reg [3:0] data_out
);
    reg [3:0] memory; // 4-bit memory cell

    always @(posedge clk) begin
        if (control) begin
            memory <= data_in; // Write data to memory
        end else begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule