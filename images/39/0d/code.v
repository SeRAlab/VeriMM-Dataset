module voltage_sensor(
    input wire clk,
    input wire reset,
    input wire [7:0] voltage, // 8-bit representation of voltage
    output reg alert
);

    parameter THRESHOLD = 8'd128; // represent 5V in an arbitrary scale

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alert <= 0;
        end else begin
            if (voltage > THRESHOLD) begin
                alert <= 1;
            end else begin
                alert <= 0;
            end
        end
    end
endmodule