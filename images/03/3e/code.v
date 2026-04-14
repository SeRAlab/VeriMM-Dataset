module bluetooth_fsm (
    input wire clk,
    input wire reset,
    input wire connect,
    input wire disconnect,
    output reg [1:0] state
);

    // State encoding
    parameter IDLE = 2'b00;
    parameter CONNECTED = 2'b01;
    parameter DISCONNECTED = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (connect) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    if (disconnect) begin
                        state <= DISCONNECTED;
                    end
                end
                DISCONNECTED: begin
                    if (connect) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule