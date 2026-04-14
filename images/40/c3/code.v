module temperature_monitor(
    input wire clk,
    input wire reset,
    input wire [4:0] temperature,
    output reg alert
);
    reg [4:0] current_temperature;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_temperature <= 5'b00000;
            alert <= 1'b0;
        end else begin
            current_temperature <= temperature;
            alert <= (current_temperature > 5'b11001) ? 1'b1 : 1'b0;
        end
    end
endmodule