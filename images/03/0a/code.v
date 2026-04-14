module dram_cell (
    input wire [7:0] D,
    input wire WE,
    input wire RE,
    output reg [7:0] Q
);

always @(posedge WE or posedge RE) begin
    if (WE) begin
        Q <= D; // Write data
    end else if (RE) begin
        // Read data (Q retains its value)
        // No assignment needed as Q is already reflecting stored data
    end
end

endmodule