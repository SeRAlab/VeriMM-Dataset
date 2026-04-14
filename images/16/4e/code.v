module eeprom_cell (
    input wire [7:0] data_in,
    input wire WE,
    output reg [7:0] data_out
);
    
    reg [7:0] memory;

    always @(*) begin
        if (WE) begin
            memory = data_in; // Store data
        end
        data_out = memory; // Output stored data
    end
endmodule