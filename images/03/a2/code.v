module voltage_level_detector(
    input [3:0] voltage,
    output reg level_detected
);
    always @(*) begin
        if (voltage > 4'b1000) // Threshold 8
            level_detected = 1'b1;
        else
            level_detected = 1'b0;
    end
endmodule