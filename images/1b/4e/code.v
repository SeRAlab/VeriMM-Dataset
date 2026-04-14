module hazard_detection (
    input A,
    input B,
    input C,
    output reg Hazard
);
    always @(*) begin
        if ((A == B) || (B == C) || (A == C)) 
            Hazard = 1;
        else 
            Hazard = 0;
    end
endmodule