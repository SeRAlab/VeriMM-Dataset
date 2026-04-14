module current_sensor (
    input [3:0] current_input,
    output reg [2:0] current_status
);

always @(*) begin
    if (current_input < 4) 
        current_status = 3'b000; // Low
    else if (current_input >= 4 && current_input <= 11) 
        current_status = 3'b001; // Medium
    else 
        current_status = 3'b010; // High
end

endmodule