module sr_flip_flop (
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    always @(posedge CLK) begin
        if (S && !R) begin
            Q <= 1;
        end else if (!S && R) begin
            Q <= 0;
        end // if S = 1 and R = 1, keep the previous state
    end

    always @(*) begin
        Qn = ~Q; // Qn is the inverse of Q
    end
endmodule