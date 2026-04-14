module sata_controller (
    input wire clk,
    input wire reset,
    input wire start_signal,
    input wire error_signal,
    output reg [1:0] state // 2-bit state representation
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter ERROR = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE
        end else begin
            case (state)
                IDLE: begin
                    if (start_signal) begin
                        state <= ACTIVE; // Transition to ACTIVE
                    end
                end
                ACTIVE: begin
                    if (error_signal) begin
                        state <= ERROR; // Transition to ERROR
                    end else begin
                        // Maintain ACTIVE if no error
                    end
                end
                ERROR: begin
                    if (reset) begin
                        state <= IDLE; // Transition to IDLE on reset
                    end
                end
            endcase
        end
    end
endmodule