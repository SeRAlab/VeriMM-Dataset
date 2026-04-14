module temperature_monitor(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature,
    output reg over_temp_flag
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            over_temp_flag <= 0;
        end else if (temperature > 8'd75) begin
            over_temp_flag <= 1;
        end else begin
            over_temp_flag <= 0;
        end
    end
endmodule