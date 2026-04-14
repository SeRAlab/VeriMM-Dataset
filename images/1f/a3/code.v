module wifi_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] cmd,
    output reg [1:0] state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // OFF state on reset
        end else begin
            case (cmd)
                2'b00: state <= 2'b00; // OFF
                2'b01: state <= 2'b01; // CONNECTING
                2'b10: state <= 2'b10; // CONNECTED
                2'b11: state <= 2'b11; // DISCONNECTING
                default: state <= state; // Maintain current state
            endcase
        end
    end
endmodule