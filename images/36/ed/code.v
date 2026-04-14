module dram_cell (
    input wire [3:0] D,
    input wire WE,
    input wire CLK,
    input wire CS,
    output reg [3:0] Q
);
    always @(posedge CLK) begin
        if (CS) begin
            if (WE) begin
                Q <= D; // Write data
            end
        end else begin
            Q <= 4'b0000; // Default state when not selected
        end
    end
endmodule