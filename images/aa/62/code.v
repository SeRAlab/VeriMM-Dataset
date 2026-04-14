module temp_monitor #(
    parameter THRESHOLD = 100
)(
    input [7:0] temperature,
    output reg alarm
);

    always @(*) begin
        if (temperature > THRESHOLD) begin
            alarm = 1;
        end else begin
            alarm = 0;
        end
    end

endmodule