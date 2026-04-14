module interrupt_controller (
    input wire [3:0] IRQ,   // 4 interrupt request signals
    input wire RST,         // reset signal
    input wire CLK,         // clock signal
    output reg INT_OUT      // interrupt output
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        INT_OUT <= 0;       // clear interrupt on reset
    end else begin
        INT_OUT <= |IRQ;    // generate output if any IRQ signal is high
    end
end

endmodule