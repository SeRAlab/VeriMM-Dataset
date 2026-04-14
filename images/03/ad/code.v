module sram_cell (
    input wire WE,    // Write Enable
    input wire RE,    // Read Enable
    input wire D,     // Data input
    output reg Q      // Data output
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;   // Write data to SRAM
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            // Output the stored value
            Q <= Q;   // keep the current Q
        end
    end
endmodule