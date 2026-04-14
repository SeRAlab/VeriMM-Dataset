module dram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Write data to cell
        end
        if (RE) begin
            // Reading does not change Q, just output it
        end
    end
endmodule