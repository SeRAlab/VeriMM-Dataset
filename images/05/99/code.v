module dram_cell (
    input wire [3:0] D,
    input wire WE,
    input wire CLK,
    output reg [3:0] Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Write data to the cell
        end
        // No else statement, Q retains its value when WE is low
    end
endmodule