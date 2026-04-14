module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] irq,
    output reg ack
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (irq[3]) begin
                        ack <= 1; // Acknowledge irq[3] (highest priority)
                        state <= 1;
                    end else if (irq[2]) begin
                        ack <= 1; // Acknowledge irq[2]
                        state <= 1;
                    end else if (irq[1]) begin
                        ack <= 1; // Acknowledge irq[1]
                        state <= 1;
                    end else if (irq[0]) begin
                        ack <= 1; // Acknowledge irq[0] (lowest priority)
                        state <= 1;
                    end
                end
                1: begin
                    ack <= 0; // Deactivate ack after one clock cycle
                    state <= 0; // Go back to initial state
                end
            endcase
        end
    end
endmodule