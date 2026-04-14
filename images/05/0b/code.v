module wifi_status_controller (
    input wire clk,
    input wire rst,
    input wire start_connect,
    input wire disconnect,
    output reg [1:0] state // 00: OFF, 01: CONNECTING, 10: CONNECTED, 11: DISCONNECTED
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // OFF
        end else begin
            case (state)
                2'b00: if (start_connect) state <= 2'b01; // OFF to CONNECTING
                2'b01: state <= 2'b10; // CONNECTING to CONNECTED
                2'b10: if (disconnect) state <= 2'b11; // CONNECTED to DISCONNECTED
                2'b11: state <= 2'b00; // DISCONNECTED to OFF
                default: state <= 2'b00; // default to OFF
            endcase
        end
    end
endmodule