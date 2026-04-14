module SRAM_4bit (
    input wire [3:0] D,
    input wire WE,
    input wire CLK,
    output reg [3:0] Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Write data to Q when WE is high
        end
        // No else needed; Q retains its value when WE is low
    end
endmodule