module voltage_sensor (
    input [4:0] voltage_in,
    output reg exceed_threshold
);
    always @(*) begin
        if (voltage_in > 5'd20)
            exceed_threshold = 1'b1;
        else
            exceed_threshold = 1'b0;
    end
endmodule