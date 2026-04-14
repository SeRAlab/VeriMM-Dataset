module hazard_detection (
    input [4:0] current_instruction, 
    input [4:0] next_instruction, 
    input [4:0] writeback_instruction,
    output reg hazard_detected
);
    
    always @(*) begin
        if ((current_instruction == next_instruction) || 
            (current_instruction == writeback_instruction)) begin
            hazard_detected = 1;
        end else begin
            hazard_detected = 0;
        end
    end
endmodule