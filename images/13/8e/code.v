module voltage_sensor(
    input wire clk,
    input wire reset,
    input wire [7:0] voltage_input,
    output reg alert
);

parameter THRESHOLD = 8'd100; // Voltage threshold

always @(posedge clk or posedge reset) begin
    if (reset) begin
        alert <= 1'b0;
    end else begin
        if (voltage_input > THRESHOLD) begin
            alert <= 1'b1;
        end else begin
            alert <= 1'b0;
        end
    end
end

endmodule