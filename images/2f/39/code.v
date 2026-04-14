module current_sensor (
    input [3:0] current,
    output reg exceeds_threshold
);
    always @(*) begin
        if (current > 4'b1000) // 8 in binary
            exceeds_threshold = 1;
        else
            exceeds_threshold = 0;
    end
endmodule