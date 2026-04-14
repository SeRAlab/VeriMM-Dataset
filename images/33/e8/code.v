module temp_sensor_comparator (
    input [3:0] temperature,
    input reset,
    output reg alert
);
    always @(*) begin
        if (reset) 
            alert = 0;
        else 
            alert = (temperature > 4'b1010) ? 1 : 0; // 10 degrees Celsius in binary
    end
endmodule