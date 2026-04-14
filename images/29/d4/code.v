module interrupt_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] interrupt_requests,
    output reg [1:0] current_interrupt
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_interrupt <= 2'b00; // Reset current interrupt
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin // Idle state
                    if (interrupt_requests != 4'b0000) begin
                        // Find the highest priority interrupt
                        if (interrupt_requests[0]) begin
                            current_interrupt <= 2'b00; // Serve interrupt 0
                        end else if (interrupt_requests[1]) begin
                            current_interrupt <= 2'b01; // Serve interrupt 1
                        end else if (interrupt_requests[2]) begin
                            current_interrupt <= 2'b10; // Serve interrupt 2
                        end else if (interrupt_requests[3]) begin
                            current_interrupt <= 2'b11; // Serve interrupt 3
                        end
                        state <= 2'b01; // Move to service state
                    end
                end
                2'b01: begin // Service state
                    // After serving, return to idle state
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule