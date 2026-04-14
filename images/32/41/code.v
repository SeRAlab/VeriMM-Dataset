module EEPROM (
    input wire [3:0] data_in,
    input wire we,       // write enable
    input wire er,       // erase signal
    input wire re,       // read enable
    output reg [3:0] data_out
);

reg [3:0] memory; // 4-bit memory cell

always @(*) begin
    if (er) begin
        memory <= 4'b0000; // erase operation
    end else if (we) begin
        memory <= data_in; // write operation
    end else if (re) begin
        data_out <= memory; // read operation
    end
end

endmodule