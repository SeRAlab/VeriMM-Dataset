module sr_flip_flop (
    input wire S,
    input wire R,
    input wire CLK,
    input wire RESET,
    output reg Q
);
    always @(posedge CLK or posedge RESET) begin
        if (RESET)
            Q <= 0;
        else if (R)
            Q <= 0;
        else if (S)
            Q <= 1;
        // If both S and R are low, Q retains its state.
    end
endmodule