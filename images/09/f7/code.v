module hazard_detection(
    input [1:0] A,
    input [1:0] B,
    input [1:0] last_A,
    input [1:0] last_B,
    input [1:0] Op,
    output reg hazard
);

always @(*) begin
    // Set default to no hazard
    hazard = 0;

    // Check for hazards
    if ((A == last_A || B == last_B) && (Op != 2'b00)) begin
        hazard = 1; // Hazard detected
    end
end

endmodule