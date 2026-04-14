module SR_Latch (
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
            // Hold state
            // Q and Qn retain their previous values
        end else if (S == 1 && R == 1) begin
            // Invalid state
            Q <= 1'bx;
            Qn <= 1'bx;
        end
    end
endmodule