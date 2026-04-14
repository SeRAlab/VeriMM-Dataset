module priority_encoder (
    input wire I3, I2, I1, I0,
    output reg O1, O0,
    output reg V
);
    always @(*) begin
        if (I3) begin
            O1 = 1; O0 = 1; V = 1; // I3 is highest priority
        end else if (I2) begin
            O1 = 1; O0 = 0; V = 1; // I2 is next highest
        end else if (I1) begin
            O1 = 0; O0 = 1; V = 1; // I1 is next
        end else if (I0) begin
            O1 = 0; O0 = 0; V = 1; // I0 is the lowest
        end else begin
            O1 = 0; O0 = 0; V = 0; // No input is active
        end
    end
endmodule