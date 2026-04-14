module eeprom_cell (
    input wire D,
    input wire WE,
    input wire CLK,
    input wire RST,
    output reg Q
);

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 1'b0; // Reset the stored value to 0
        end else if (WE) begin
            Q <= D; // Store the data input
        end
    end
endmodule