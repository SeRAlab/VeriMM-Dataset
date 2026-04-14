module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq,
    output reg int_ack,
    output reg [1:0] highest_priority
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            int_ack <= 0;
            highest_priority <= 2'b00;
        end else begin
            case (irq)
                4'b0001: begin
                    int_ack <= 1;
                    highest_priority <= 2'b00; // IRQ0
                end
                4'b0010: begin
                    int_ack <= 1;
                    highest_priority <= 2'b01; // IRQ1
                end
                4'b0100: begin
                    int_ack <= 1;
                    highest_priority <= 2'b10; // IRQ2
                end
                4'b1000: begin
                    int_ack <= 1;
                    highest_priority <= 2'b11; // IRQ3
                end
                default: begin
                    int_ack <= 0; // No interrupt
                    highest_priority <= 2'b00; // Default to 0
                end
            endcase
        end
    end
endmodule