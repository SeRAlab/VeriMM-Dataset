module dram_cell (
    input wire D,          // Data input
    input wire WE,         // Write Enable
    input wire RE,         // Read Enable
    output reg Q          // Stored value output
);
    
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;      // Write operation
        end 
    end

    always @(posedge RE) begin
        // Output the stored value
        if (RE) begin
            Q <= Q;      // Read operation (retains Q)
        end
    end

endmodule