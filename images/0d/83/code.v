module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire frame_valid,
    output reg [1:0] state
);
    parameter IDLE = 2'b00;
    parameter TRANSMIT = 2'b01;
    parameter WAIT = 2'b10;
    parameter ERROR = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (frame_valid) begin
                        state <= TRANSMIT;
                    end
                end
                TRANSMIT: begin
                    if (start) begin
                        state <= WAIT;
                    end else begin
                        state <= ERROR; // Simulated error if start is not asserted
                    end
                end
                WAIT: begin
                    state <= IDLE; // Go back to IDLE after WAIT
                end
                ERROR: begin
                    state <= IDLE; // Reset to IDLE on ERROR
                end
            endcase
        end
    end
endmodule