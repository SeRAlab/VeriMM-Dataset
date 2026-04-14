module temperature_sensor(
    input [4:0] temp, // 5-bit temperature input
    output reg [1:0] status // 2-bit output status
);

parameter THRESHOLD = 5'd25; // Threshold value for comparison

always @(*) begin
    if (temp < THRESHOLD) 
        status = 2'b00; // Below threshold
    else if (temp == THRESHOLD) 
        status = 2'b01; // Equal to threshold
    else 
        status = 2'b10; // Above threshold
end

endmodule