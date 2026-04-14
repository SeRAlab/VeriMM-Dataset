module voltage_sensor (
    input wire clk,
    input wire reset,
    input wire [7:0] voltage_input,
    input wire [7:0] threshold,
    output reg alert
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alert <= 0;
    end else begin
        if (voltage_input > threshold) begin
            alert <= 1;
        end else begin
            alert <= 0;
        end
    end
end

endmodule