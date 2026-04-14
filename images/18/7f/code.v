module wifi_power_controller(
    input wire clk,
    input wire reset,
    input wire power_enable,
    output reg wifi_power
);
    reg [1:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            wifi_power <= 0;
        end else begin
            case (state)
                2'b00: begin // Idle state
                    if (power_enable) begin
                        state <= 2'b01; // Transition to powering up
                    end
                end
                2'b01: begin // Powering up state
                    state <= 2'b10; // Move to the next state
                end
                2'b10: begin // Powered on state
                    wifi_power <= 1; // WiFi is powered on
                    if (!power_enable) begin
                        state <= 2'b00; // Go back to Idle state
                        wifi_power <= 0; // WiFi is powered off
                    end
                end
            endcase
        end
    end
endmodule