module dram_cell (
    input wire [15:0] D,
    input wire RW,
    input wire CLK,
    output reg [15:0] Q
);

always @(posedge CLK) begin
    if (RW) begin
        Q <= D; // Write operation
    end else begin
        // Read operation, Q retains the stored value
        // No action needed since Q is already driven by the stored value
    end
end

endmodule