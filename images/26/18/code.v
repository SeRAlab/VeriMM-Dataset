module eeprom_cell (
    input wire wr,  // write signal
    input wire rd,  // read signal
    input wire d,   // data input
    output reg q    // data output
);
    always @(posedge wr) begin
        q <= d;  // store data on write
    end

    always @(posedge rd) begin
        // output current stored value
        // no action needed, q will hold the value
    end
endmodule