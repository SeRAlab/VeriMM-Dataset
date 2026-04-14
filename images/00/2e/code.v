module sram_cell (
    input wire WE,      // Write Enable
    input wire RE,      // Read Enable
    input wire D,       // Input Data
    output reg Q        // Output Data
);

always @(posedge WE or posedge RE) begin
    if (WE) begin
        Q <= D;          // Store data when WE is high
    end
end

always @(posedge RE) begin
    if (RE) begin
        // Q will output the stored data when RE is high
    end
end

endmodule