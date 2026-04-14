module eeprom_cell (
    input [7:0] data_in,
    input rw, // read/write control signal
    output reg [7:0] data_out
);
    reg [7:0] memory; // internal memory to store data

    always @(*) begin
        if (rw) begin
            memory = data_in; // write data to memory
        end else begin
            data_out = memory; // read data from memory
        end
    end
endmodule