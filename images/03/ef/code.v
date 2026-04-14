module bluetooth_fsm (
    input clk,
    input reset,
    input start_connect,
    input connection_success,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE; // Reset to IDLE
        end else begin
            case (state)
                IDLE: begin
                    if (start_connect) begin
                        state <= CONNECTING;
                    end
                end
                CONNECTING: begin
                    if (connection_success) begin
                        state <= CONNECTED;
                    end else begin
                        state <= IDLE; // Connection failed
                    end
                end
                CONNECTED: begin
                    state <= IDLE; // Reset on successful connection
                end
                default: state <= IDLE; // Default case
            endcase
        end
    end
endmodule