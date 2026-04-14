module dram_cell (
    input wire clk,
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);

always @(posedge clk) begin
    if (WE) begin
        Q <= D; // Write data to the cell
    end
end

always @(posedge clk) begin
    if (RE) begin
        // Reading is implicit since Q will hold the last written value
    end
end

endmodule