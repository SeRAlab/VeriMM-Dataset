module temperature_shutdown(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg shutdown_signal
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown_signal <= 0;
        end else begin
            if (temperature > 75) begin
                shutdown_signal <= 1;
            end else begin
                shutdown_signal <= 0;
            end
        end
    end
endmodule