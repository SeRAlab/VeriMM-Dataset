module Interrupt_Controller (
    input wire [3:0] IRQ,    // 4 interrupt requests
    input wire EN,           // Enable signal
    output reg INT_OUT       // Interrupt output
);
    always @(*) begin
        if (EN) begin
            casez (IRQ)
                4'b1???: INT_OUT = 1; // IRQ0
                4'b01??: INT_OUT = 1; // IRQ1
                4'b001?: INT_OUT = 1; // IRQ2
                4'b0001: INT_OUT = 1; // IRQ3
                default: INT_OUT = 0;  // No interrupt
            endcase
        end else begin
            INT_OUT = 0; // Disable output
        end
    end
endmodule