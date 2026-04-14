module current_sensor (
    input [7:0] current_voltage, // 8-bit input representing current in mA
    output reg current_exceeds_threshold // 1-bit output
);
    parameter THRESHOLD = 100; // 100 mA threshold

    always @(*) begin
        if (current_voltage > THRESHOLD)
            current_exceeds_threshold = 1;
        else
            current_exceeds_threshold = 0;
    end
endmodule