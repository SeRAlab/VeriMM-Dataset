module current_sensor (
    input [4:0] current_input,
    output reg [2:0] current_status
);
    always @(*) begin
        if (current_input <= 5'd7) begin
            current_status = 3'b000; // Low current
        end else if (current_input <= 5'd15) begin
            current_status = 3'b001; // Medium current
        end else if (current_input <= 5'd31) begin
            current_status = 3'b010; // High current
        end else begin
            current_status = 3'b111; // Overflow
        end
    end
endmodule