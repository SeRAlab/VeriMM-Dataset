module dram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE) begin
        Q <= D; // Store data when WE is high
    end

    always @(posedge RE) begin
        // Output stored data when RE is high
        // No operation needed here since Q will hold the value
    end
endmodule