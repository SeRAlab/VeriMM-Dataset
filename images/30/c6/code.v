module dram_cell (
    input wire D,        // Data input
    input wire WE,      // Write Enable
    input wire RE,      // Read Enable
    output reg Q        // Data output
);

    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;      // Store the data when WE is high
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            // Do nothing, Q will output the stored data automatically
        end
    end

endmodule