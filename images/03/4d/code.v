module wifi_controller(
    input wire clk,
    input wire reset,
    input wire connect,
    input wire disconnect,
    output reg [1:0] state // 0: Disconnected, 1: Connecting, 2: Connected
);

    // State encoding
    localparam DISCONNECTED = 2'b00;
    localparam CONNECTING = 2'b01;
    localparam CONNECTED = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= DISCONNECTED;
        end else begin
            case (state)
                DISCONNECTED: begin
                    if (connect)
                        state <= CONNECTING;
                end
                CONNECTING: begin
                    if (connect)
                        state <= CONNECTED;
                end
                CONNECTED: begin
                    if (disconnect)
                        state <= DISCONNECTED;
                end
            endcase
        end
    end
endmodule