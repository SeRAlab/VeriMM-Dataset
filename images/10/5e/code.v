module SRAM_Cell (
    input wire [7:0] D,
    input wire WE,
    input wire CLK,
    output reg [7:0] Q
);
    
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Write data on rising edge of CLK
        end
    end
    
endmodule