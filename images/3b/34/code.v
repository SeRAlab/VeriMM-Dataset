module current_sensor (
    input [4:0] current_input,
    output reg [2:0] status_output
);

always @(*) begin
    if (current_input < 5'b00000) begin
        status_output = 3'b001; // Low current
    end else if (current_input > 5'b01111) begin
        status_output = 3'b111; // High current
    end else begin
        status_output = 3'b000; // Safe current
    end
end

endmodule