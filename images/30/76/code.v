module dram_cell (
    input wire D,     // Data input
    input wire WE,    // Write enable
    input wire RE,    // Read enable
    output reg Q      // Data output
);
    always @(posedge WE) begin
        Q <= D; // Write data to cell when WE is high
    end
    
    always @(posedge RE) begin
        // Reading is done asynchronously; Q holds the last written value when RE is high
    end
endmodule