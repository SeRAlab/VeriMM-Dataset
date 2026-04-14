module sram_cell (
    input wire D,      // Data input
    input wire WE,     // Write enable
    input wire RE,     // Read enable
    output reg Q       // Stored data output
);
    always @(*) begin
        if (WE) begin
            Q <= D;     // Write the data to the cell
        end
    end

    always @(*) begin
        if (RE) begin
            // Read the data from the cell
            // Q will hold the data if RE is high
            // The value of Q remains unchanged if RE is not high
        end
    end
endmodule