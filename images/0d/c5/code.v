module interrupt_controller (
    input clk,
    input reset,
    input [3:0] interrupt_enable, // Enable signals for each interrupt
    input [3:0] interrupt_request, // Interrupt request signals
    input clear,                 // Clear signal
    output reg [1:0] current_interrupt // Current interrupt being serviced (2-bits)
);
    reg [3:0] enabled_interrupts;
    reg [1:0] next_interrupt;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_interrupt <= 2'b00;
            enabled_interrupts <= 4'b0000;
        end else if (clear) begin
            current_interrupt <= 2'b00;
        end else begin
            enabled_interrupts <= interrupt_enable & interrupt_request;
            if (enabled_interrupts != 4'b0000) begin
                // Find next interrupt in round-robin fashion
                case (current_interrupt)
                    2'b00: next_interrupt = (enabled_interrupts[0]) ? 2'b00 : (enabled_interrupts[1]) ? 2'b01 : (enabled_interrupts[2]) ? 2'b10 : 2'b11;
                    2'b01: next_interrupt = (enabled_interrupts[1]) ? 2'b01 : (enabled_interrupts[2]) ? 2'b10 : (enabled_interrupts[3]) ? 2'b11 : 2'b00;
                    2'b10: next_interrupt = (enabled_interrupts[2]) ? 2'b10 : (enabled_interrupts[3]) ? 2'b11 : (enabled_interrupts[0]) ? 2'b00 : 2'b01;
                    2'b11: next_interrupt = (enabled_interrupts[3]) ? 2'b11 : (enabled_interrupts[0]) ? 2'b00 : (enabled_interrupts[1]) ? 2'b01 : 2'b10;
                    default: next_interrupt = 2'b00;
                endcase
                current_interrupt <= next_interrupt;
            end
        end
    end
endmodule