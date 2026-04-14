module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] irq, // 4 interrupt requests
    output reg irq_ack,    // interrupt acknowledge
    output reg irq_out,    // active interrupt signal
    output reg ready       // processing complete signal
);

    reg [1:0] current_priority; // to hold the current highest priority interrupt
    reg [3:0] irq_pending;       // to hold pending interrupts

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            irq_ack <= 0;
            irq_out <= 0;
            ready <= 1;
            current_priority <= 2'b00;
            irq_pending <= 4'b0000;
        end else begin
            // Check for active interrupts
            irq_pending <= irq;
            if (irq_pending != 4'b0000 && ready) begin
                // Find highest priority interrupt
                current_priority <= (irq_pending[3] ? 2'b11 :
                                    (irq_pending[2] ? 2'b10 :
                                    (irq_pending[1] ? 2'b01 : 2'b00)));
                
                // Acknowledge the interrupt
                irq_ack <= 1;
                irq_out <= (1 << current_priority);
                ready <= 0;
            end else if (!ready) begin
                // Process complete
                irq_ack <= 0;
                ready <= 1;
            end
        end
    end
endmodule