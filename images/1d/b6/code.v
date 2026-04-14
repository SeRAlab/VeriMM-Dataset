module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);

always @ (S or R) begin
    if (S && !R) begin
        Q <= 1;
        Qn <= 0;
    end else if (!S && R) begin
        Q <= 0;
        Qn <= 1;
    end else if (S && R) begin
        // Invalid state: both S and R are high
        Q <= 1'bx; // or you can define a specific behavior
        Qn <= 1'bx;
    end
end

endmodule