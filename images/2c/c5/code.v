module eeprom_cell (
    input [4:0] data_in,
    input load,
    input read,
    output reg [4:0] data_out
);
    always @(*) begin
        if (load) begin
            data_out = data_in; // Load the input data into the output
        end
    end
endmodule