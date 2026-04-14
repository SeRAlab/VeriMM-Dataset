module temperature_sensor (
    input [3:0] temperature,
    output reg alert
);
    always @(*) begin
        if (temperature > 4'b1010) // 10 in binary
            alert = 1'b1; // Alert if above 10
        else
            alert = 1'b0; // No alert
    end
endmodule