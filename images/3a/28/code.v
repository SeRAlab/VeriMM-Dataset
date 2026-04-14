module temperature_shutdown(
    input clk,
    input reset,
    input [7:0] temperature,
    input [7:0] threshold,
    output reg shutdown
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shutdown <= 0;
        end else if (temperature > threshold) begin
            shutdown <= 1;
        end else begin
            shutdown <= 0;
        end
    end
endmodule