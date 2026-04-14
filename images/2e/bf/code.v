module hazard_detection (
    input [4:0] rs1,      // Source register 1
    input [4:0] rs2,      // Source register 2
    input [4:0] rd,       // Destination register
    output reg hazard      // Hazard detected signal
);

always @(*) begin
    if (rd != 5'b00000 && (rd == rs1 || rd == rs2)) begin
        hazard = 1'b1; // Hazard detected
    end else begin
        hazard = 1'b0; // No hazard
    end
end

endmodule