module temperature_sensor (
    input wire clk,
    input wire [4:0] temperature,
    output reg [1:0] status
);
    always @(posedge clk) begin
        if (temperature <= 5'd10) begin
            status <= 2'b00; // Low
        end else if (temperature <= 5'd20) begin
            status <= 2'b01; // Normal
        end else begin
            status <= 2'b10; // High
        end
    end
endmodule