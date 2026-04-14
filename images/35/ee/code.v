module pitch_detector(
    input [4:0] frequency,
    output reg [2:0] pitch_category
);

always @(*) begin
    if (frequency < 5'd10) begin
        pitch_category = 3'b000; // Low
    end else if (frequency < 5'd20) begin
        pitch_category = 3'b001; // Medium
    end else begin
        pitch_category = 3'b010; // High
    end
end

endmodule