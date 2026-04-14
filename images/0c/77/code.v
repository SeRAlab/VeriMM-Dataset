module current_sensor(
    input [4:0] current_level, // 5-bit input for current level
    output reg [2:0] status    // 3-bit output for status
);

always @(*) begin
    if (current_level < 5'd10)          // Current is low
        status = 3'b000;
    else if (current_level >= 5'd10 && current_level < 5'd20) // Current is normal
        status = 3'b001;
    else                                  // Current is high
        status = 3'b010;
end
endmodule