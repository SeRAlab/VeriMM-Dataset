module wifi_control (
    input wire clk,
    input wire rst,
    input wire [2:0] state,
    output reg active
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            active <= 0; // IDLE state
        end else begin
            case (state)
                3'b001: active <= 1; // CONNECTING
                3'b010: active <= 1; // CONNECTED
                default: active <= 0; // IDLE, DISCONNECTING, DISCONNECTED
            endcase
        end
    end
endmodule