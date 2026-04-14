module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @ (S or R) begin
        if (S == 1 && R == 0) begin
            Q <= 1;
            Qn <= 0;
        end else if (S == 0 && R == 1) begin
            Q <= 0;
            Qn <= 1;
        end else if (S == 0 && R == 0) begin
            // Maintain the current state
            Q <= Q;
            Qn <= Qn;
        end else begin
            // Invalid state
            Q <= Q;  // Maintain current state
            Qn <= Qn;  // Maintain current state
        end
    end
endmodule