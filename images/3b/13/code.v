module bluetooth_module (
    input wire clk,
    input wire reset,
    input wire connect,
    output reg led
);

reg state; // 0 = disconnected, 1 = connected

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // on reset, set to disconnected
        led <= 0;   // LED off
    end else begin
        if (connect) begin
            state <= ~state; // toggle state on connect
        end
        led <= state; // update LED based on state
    end
end

endmodule