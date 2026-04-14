module eeprom_cell (
    input wire D,
    input wire write,
    input wire read,
    input wire reset,
    output reg Q
);
    always @(posedge write or posedge reset) begin
        if (reset) begin
            Q <= 0; // clear the cell
        end else begin
            Q <= D; // write data to the cell
        end
    end

    always @(posedge read) begin
        // read operation is simply to output the current value of Q
        // No action required since Q is already updated by write/reset
    end
endmodule