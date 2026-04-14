module EEPROM (
    input wire [7:0] data_in,
    input wire we,
    input wire re,
    input wire rst,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge we or posedge rst) begin
        if (rst) begin
            memory <= 8'b00000000;  // Initialize memory to 0
        end else begin
            memory <= data_in;       // Write data to memory
        end
    end

    always @(posedge re) begin
        data_out <= memory;        // Read data from memory
    end
endmodule