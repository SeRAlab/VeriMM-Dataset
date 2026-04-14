module current_sensor (
    input [4:0] current_level,
    output reg [2:0] status
);

always @(*) begin
    if (current_level <= 5'd10) begin
        status = 3'b000; // Current level 0-10
    end else if (current_level <= 5'd20) begin
        status = 3'b001; // Current level 11-20
    end else if (current_level <= 5'd30) begin
        status = 3'b010; // Current level 21-30
    end else begin
        status = 3'b011; // Current level > 30
    end
end

endmodule