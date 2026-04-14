module bluetooth_fsm (
    input clk,
    input reset,
    input start,
    input connect,
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
                    if (connect) begin
                        state <= CONNECTED;
                    end
                end
                CONNECTED: begin
                    if (reset) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule