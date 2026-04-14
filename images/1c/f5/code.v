module bluetooth_fsm(
    input wire clk,
    input wire reset,
    input wire control,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, CONNECTING = 2'b01, CONNECTED = 2'b10, DISCONNECTED = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (control) state <= CONNECTING;
                CONNECTING: if (control) state <= CONNECTED;
                CONNECTED: if (!control) state <= DISCONNECTED;
                DISCONNECTED: if (!control) state <= IDLE;
            endcase
        end
    end
endmodule