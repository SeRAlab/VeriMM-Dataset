module interrupt_controller (
    input wire [3:0] interrupt_req,
    input wire clk,
    input wire rst,
    output reg [1:0] interrupt_ack
);
    reg [1:0] current_interrupt;
    reg [3:0] pending_interrupts;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            interrupt_ack <= 2'b00;
            current_interrupt <= 2'b00;
            pending_interrupts <= 4'b0000;
        end else begin
            pending_interrupts <= interrupt_req;
            if (pending_interrupts != 4'b0000) begin
                if (interrupt_ack == 2'b00) begin
                    // Acknowledge the first available interrupt
                    case (pending_interrupts)
                        4'b0001: interrupt_ack <= 2'b00; // Acknowledge interrupt 0
                        4'b0010: interrupt_ack <= 2'b01; // Acknowledge interrupt 1
                        4'b0100: interrupt_ack <= 2'b10; // Acknowledge interrupt 2
                        4'b1000: interrupt_ack <= 2'b11; // Acknowledge interrupt 3
                        default: begin
                            if (pending_interrupts[0]) interrupt_ack <= 2'b00;
                            else if (pending_interrupts[1]) interrupt_ack <= 2'b01;
                            else if (pending_interrupts[2]) interrupt_ack <= 2'b10;
                            else if (pending_interrupts[3]) interrupt_ack <= 2'b11;
                        end
                    endcase
                end else begin
                    current_interrupt <= interrupt_ack; // Store the current acknowledged interrupt
                    interrupt_ack <= 2'b00; // Reset to acknowledge the next interrupt
                end
            end
        end
    end
endmodule