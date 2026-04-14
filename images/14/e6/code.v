module flash_memory_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;  // Write data to the memory cell
        end
        if (RE) begin
            // Do nothing; Q retains its value if WE is not active
        end
    end
endmodule