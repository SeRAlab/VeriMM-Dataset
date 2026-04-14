module eeprom_cell (
    input wire clk,
    input wire we, // write enable
    input wire re, // read enable
    input wire [7:0] data_in, // input data
    output reg [7:0] data_out // output data
);
    reg [7:0] memory; // Internal memory to store the data

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
        if (re) begin
            data_out <= memory; // Read operation
        end
    end
endmodule