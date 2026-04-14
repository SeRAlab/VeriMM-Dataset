module hazard_detection (
    input [4:0] rs1,      // Source register 1
    input [4:0] rs2,      // Source register 2
    input [4:0] rt,       // Destination register
    input mem_read,       // Memory read signal from the EX stage
    output reg stall       // Stall signal
);

always @(*) begin
    if (mem_read && (rs1 == rt || rs2 == rt)) begin
        stall = 1; // Hazard detected, need to stall
    end else begin
        stall = 0; // No hazard
    end
end

endmodule