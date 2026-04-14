module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q,
    output reg Qn
);
    always @(posedge clk) begin
        if (S && !R)
            Q <= 1'b1;
        else if (!S && R)
            Q <= 1'b0;
        // if S and R are both 1, the state remains the same
        Qn <= ~Q;
    end
endmodule