module current_sensor_comparator(
    input [7:0] current_a,
    input [7:0] current_b,
    output reg greater,
    output reg equal
);
    always @(*) begin
        if (current_a > current_b) begin
            greater = 1;
            equal = 0;
        end else if (current_a < current_b) begin
            greater = 0;
            equal = 0;
        end else begin
            greater = 0;
            equal = 1;
        end
    end
endmodule