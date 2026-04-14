module voltage_sensor(
    input [4:0] voltage,
    output reg alert
);
    parameter THRESHOLD = 5'b10000; // Threshold value of 16
    always @(*) begin
        if (voltage >= THRESHOLD)
            alert = 1'b1; // Alert high if voltage exceeds threshold
        else
            alert = 1'b0; // Alert low otherwise
    end
endmodule