module interrupt_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] irq,         // Interrupt requests
    input wire [1:0] int_ack,     // Acknowledge signal (2 bits to select IRQ0-IRQ3)
    output reg int_out,           // Interrupt output
    output reg [3:0] int_status    // Status of interrupts
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            int_out <= 0;
            int_status <= 4'b0000;
        end else begin
            // Update interrupt output and status
            int_status <= irq;
            int_out <= |irq; // Set output if any IRQ is active

            // Clear the acknowledged interrupt
            if (int_ack < 4) begin
                int_status[int_ack] <= 0;
            end
        end
    end
endmodule