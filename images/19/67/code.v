module interrupt_controller(
    input clk,
    input rst_n,
    input [3:0] irq,          // Interrupt requests
    input [3:0] enable,       // Enable for each IRQ
    input global_enable,      // Global enable for interrupts
    output reg [1:0] serviced  // Output indicating which interrupt is being serviced
);
    reg [3:0] irq_status;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            serviced <= 2'b00;
            irq_status <= 4'b0000;
        end else if (global_enable) begin
            irq_status <= irq & enable; // Only take enabled IRQs
            case (1'b1)
                irq_status[0]: serviced <= 2'b00; // IRQ0 serviced
                irq_status[1]: serviced <= 2'b01; // IRQ1 serviced
                irq_status[2]: serviced <= 2'b10; // IRQ2 serviced
                irq_status[3]: serviced <= 2'b11; // IRQ3 serviced
                default: serviced <= serviced; // No change if no IRQ
            endcase
        end
    end
endmodule