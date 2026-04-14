module temperature_sensor (
    input wire clk,
    input wire reset,
    input wire [3:0] temp_input,
    output reg temp_exceeds_threshold
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            temp_exceeds_threshold <= 0;
        end else begin
            if (temp_input > 4'b1010) // 10 in binary
                temp_exceeds_threshold <= 1;
            else
                temp_exceeds_threshold <= 0;
        end
    end
endmodule