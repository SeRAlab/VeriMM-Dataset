module hazard_detection(
    input [4:0] src_reg_1,
    input [4:0] src_reg_2,
    input [4:0] dest_reg,
    output reg hazard_detected
);
    always @(*) begin
        if ((src_reg_1 == dest_reg) || (src_reg_2 == dest_reg)) begin
            hazard_detected = 1'b1; // Hazard detected
        end else begin
            hazard_detected = 1'b0; // No hazard
        end
    end
endmodule