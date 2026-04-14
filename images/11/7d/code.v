module sram_cell (
    input wire D,
    input wire RE,
    input wire WE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Write data to SRAM cell
        end
    end
    
    always @(posedge RE) begin
        if (RE) begin
            // Reading data from SRAM cell
            Q <= Q; // Output the current stored value
        end
    end
endmodule