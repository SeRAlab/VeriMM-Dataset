module hazard_detection(
    input [2:0] opcode1,
    input [2:0] opcode2,
    output reg hazard
);
    always @(*) begin
        if (opcode1 == opcode2 || 
            (opcode1 == 3'b010 && opcode2 == 3'b011) || 
            (opcode1 == 3'b011 && opcode2 == 3'b010)) 
        begin
            hazard = 1;
        end else begin
            hazard = 0;
        end
    end
endmodule