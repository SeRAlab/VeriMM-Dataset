module eeprom_cell (
    input wire [7:0] D,     // Data input
    input wire WE,          // Write enable
    input wire RE,          // Read enable
    output reg [7:0] Q      // Data output
);

    always @(*) begin
        if (WE) begin
            Q = D;           // Write data to Q
        end else if (RE) begin
            // Read operation, Q retains its value
            Q = Q;           // Hold state
        end
        // If both WE and RE are low, Q holds its previous value
    end
endmodule