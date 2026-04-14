module eeprom_cell (
    input wire [4:0] data_in,
    input wire we, // write enable
    input wire re, // read enable
    output reg [4:0] data_out
);
    reg [4:0] mem; // memory register

    always @(*) begin
        if (we) begin
            mem <= data_in; // write data to memory
        end
        if (re) begin
            data_out <= mem; // read data from memory
        end else begin
            data_out <= 5'b0; // output zero if not reading
        end
    end
endmodule