module wifi_status_monitor (
    input wire clk,
    input wire reset,
    input wire wifi_connected,
    output reg [1:0] status // 00: Disconnected, 01: Connected
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= 2'b00; // Disconnected
        end else begin
            if (wifi_connected) begin
                status <= 2'b01; // Connected
            end else begin
                status <= 2'b00; // Disconnected
            end
        end
    end
endmodule