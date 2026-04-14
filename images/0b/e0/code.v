module wifi_control(
    input clk,
    input reset,
    input scan_request,
    input connect_request,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, SCANNING = 2'b01, CONNECTING = 2'b10, CONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (scan_request)
                        state <= SCANNING;
                end
                SCANNING: begin
                    if (connect_request)
                        state <= CONNECTING;
                end
                CONNECTING: begin
                    state <= CONNECTED;
                end
                CONNECTED: begin
                    // Stay in CONNECTED state until reset
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule