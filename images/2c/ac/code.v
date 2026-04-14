module bluetooth_fsm (
    input wire clk,
    input wire rst,
    input wire start_connect,
    input wire connection_success,
    input wire connection_fail,
    output reg [1:0] state
);

    // Define state encoding
    parameter IDLE = 2'b00;
    parameter CONNECTING = 2'b01;
    parameter CONNECTED = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
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
                    end else if (connection_fail) begin
                        state <= IDLE;
                    end
                end
                CONNECTED: begin
                    // Remain in CONNECTED until reset
                end
            endcase
        end
    end
endmodule