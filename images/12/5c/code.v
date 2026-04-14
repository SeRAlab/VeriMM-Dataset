module hazard_detection (
    input wire A,
    input wire B,
    input wire C,
    output reg hazard
);
    always @(*) begin
        if ((A && B && !C) || (!A && !B && C) || (A && !B && C) || (!A && B && !C)) begin
            hazard = 1;
        end else begin
            hazard = 0;
        end
    end
endmodule