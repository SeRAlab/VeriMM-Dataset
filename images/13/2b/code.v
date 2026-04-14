module hazard_detection(
    input a,
    input b,
    output reg y
);
    always @(*) begin
        if (a && b) begin
            y = 1; // Both inputs are high
        end else begin
            y = 0; // At least one input is low
        end
    end
endmodule