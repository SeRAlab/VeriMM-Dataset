module eeprom_cell (
    input wire [7:0] data_in,
    input wire we,
    input wire re,
    input wire erase,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge we or posedge erase) begin
        if (erase) begin
            memory <= 8'b0;  // Erase the memory
        end else if (we) begin
            memory <= data_in;  // Write data
        end
    end

    always @(posedge re) begin
        if (re) begin
            data_out <= memory;  // Read data
        end
    end
endmodule