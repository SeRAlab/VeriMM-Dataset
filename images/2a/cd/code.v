module wifi_controller (
    input clk,
    input reset,
    input start,
    input success,
    output reg [1:0] state
);

    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    if (success) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    state <= IDLE; // Return to IDLE after being connected
                end
            endcase
        end
    end
endmodule