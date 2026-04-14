module eeprom (
    input wire D,      // Data input
    input wire WE,     // Write enable
    input wire RE,     // Read enable
    output reg Q       // Data output
);
    // Internal storage for the EEPROM cell
    reg stored_data;

    always @(posedge WE or posedge RE) begin
        if (WE) begin
            stored_data <= D; // Write data to the cell
        end
    end

    always @(posedge RE) begin
        Q <= stored_data; // Read data from the cell
    end
endmodule