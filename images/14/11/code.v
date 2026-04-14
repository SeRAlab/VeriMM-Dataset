module current_sensor (
    input [9:0] current_voltage,
    input [9:0] threshold,
    output reg current_exceeds
);

always @(*) begin
    if (current_voltage > threshold) begin
        current_exceeds = 1'b1;
    end else begin
        current_exceeds = 1'b0;
    end
end

endmodule