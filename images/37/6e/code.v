module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq, // 4 interrupt request lines
    output reg ack,
    output reg [1:0] current_irq // 2 bits to represent which IRQ is serviced
);
    reg [1:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Idle state
            ack <= 0;
            current_irq <= 2'b00;
        end else begin
            case (state)
                2'b00: begin // Idle state
                    if (|irq) begin // If any IRQ is asserted
                        ack <= 1;
                        current_irq <= irq[3] ? 2'b11 :
                                       irq[2] ? 2'b10 :
                                       irq[1] ? 2'b01 :
                                       2'b00; // Priority for IRQ
                        state <= 2'b01; // Move to processing state
                    end
                end
                2'b01: begin // Processing state
                    // Assume processing takes one clock cycle
                    ack <= 0; // De-assert ACK after processing
                    state <= 2'b00; // Return to idle
                end
            endcase
        end
    end
endmodule