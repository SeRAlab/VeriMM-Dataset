module SRAM_Cell (
    input [3:0] D,
    input WE,
    input CLK,
    output reg [3:0] Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Write data to SRAM cell
        end
    end
endmodule