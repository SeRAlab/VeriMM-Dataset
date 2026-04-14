module hazard_detection (
    input A,
    input B,
    output reg Y
);
    always @(*) begin
        if (A && B) begin
            Y = 1;
        end else if (A && !B) begin
            Y = 1;
        end else if (!A && B) begin
            Y = 1;
        end else begin
            Y = 0;
        end
    end
endmodule