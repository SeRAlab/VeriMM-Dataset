module dram_cell (
    input wire D,
    input wire WE,
    input wire RST,
    output reg Q
);
    always @(posedge WE or posedge RST) begin
        if (RST) begin
            Q <= 0; // Clear the cell
        end else begin
            Q <= D; // Store the input data
        end
    end
endmodule