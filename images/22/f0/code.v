module current_sensor (
    input [7:0] voltage, // 0 to 255 represents 0V to 2.55V
    output reg [1:0] status // 0: safe, 1: caution, 2: danger
);

always @(*) begin
    if (voltage < 8'd40) // below 1V
        status = 2'b00;
    else if (voltage < 8'd80) // between 1V and 2V
        status = 2'b01;
    else // above 2V
        status = 2'b10;
end

endmodule