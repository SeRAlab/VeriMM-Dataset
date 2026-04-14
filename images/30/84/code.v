module bluetooth_control (
    input wire clk,
    input wire reset,
    input wire start_connect,
    input wire disconnect,
    input wire connection_success,
    output reg [1:0] state // 00: IDLE, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);

    // State encoding
    localparam IDLE        = 2'b00;
    localparam CONNECTING  = 2'b01;
    localparam CONNECTED   = 2'b10;
    localparam DISCONNECTED = 2'b11;

    // Sequential logic for state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
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
                    end else if (disconnect) begin
                        state <= DISCONNECTED;
                    end
                end
                CONNECTED: begin
                    if (disconnect) begin
                        state <= DISCONNECTED;
                    end
                end
                DISCONNECTED: begin
                    if (start_connect) begin
                        state <= CONNECTING;
                    end
                end
            endcase
        end
    end
endmodule