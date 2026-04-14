module edge_detector (
    input wire clk,
    input wire rst,
    input wire signal_in,
    output reg pulse_out
);
    reg [2:0] state;
    parameter IDLE = 3'b000, DETECT = 3'b001, PULSE = 3'b010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            pulse_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (signal_in) begin
                        state <= DETECT;
                    end
                end
                DETECT: begin
                    state <= PULSE;
                    pulse_out <= 1; // Start the pulse
                end
                PULSE: begin
                    if (pulse_out) begin
                        // Stay high for 2 clock cycles
                        pulse_out <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule