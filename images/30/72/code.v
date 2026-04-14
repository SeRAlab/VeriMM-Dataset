module interrupt_controller(
    input clk,
    input reset,
    input [3:0] irq,        // 4 interrupt requests
    input global_enable,    // Global enable signal
    output reg int_signal,   // Interrupt signal
    output reg ack_signal    // Acknowledge signal
);
    reg [1:0] state; // State variable to store the current state of the controller
    reg [3:0] irq_mask; // Mask to determine which IRQ is active

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            int_signal <= 0;
            ack_signal <= 0;
            state <= 0;
            irq_mask <= 0;
        end else begin
            if (global_enable) begin
                irq_mask <= irq; // Store the current IRQs
                if (irq_mask != 0) begin
                    int_signal <= 1; // Set interrupt signal if any IRQ is active
                    state <= 1; // Move to the service state
                end
            end
            
            if (state == 1) begin
                ack_signal <= 1; // Acknowledge the interrupt
                int_signal <= 0; // Clear interrupt signal after acknowledging
                state <= 0; // Return to idle state
            end else begin
                ack_signal <= 0; // Clear acknowledge signal
            end
        end
    end
endmodule