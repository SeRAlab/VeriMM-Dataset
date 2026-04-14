module bluetooth_controller (
    input wire clk,
    input wire reset,
    input wire start_connection,
    input wire disconnect,
    output reg state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0; // Disconnected state
        end else begin
            if (start_connection) begin
                state <= 1; // Connected state
            end else if (disconnect) begin
                state <= 0; // Disconnected state
            end
        end
    end
endmodule