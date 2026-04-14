module hazard_detection (
    input [31:0] current_inst,
    input [31:0] prev_inst,
    input control,
    output reg hazard_signal
);

always @(*) begin
    if ((current_inst[25:21] == prev_inst[20:16] || 
         current_inst[25:21] == prev_inst[15:11]) && control) begin
        hazard_signal = 1'b1; // Hazard detected
    end else begin
        hazard_signal = 1'b0; // No hazard
    end
end

endmodule