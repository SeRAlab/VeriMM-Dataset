module JK_flip_flop (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J == 1 && K == 0)
            Q <= 1;
        else if (J == 0 && K == 1)
            Q <= 0;
        else if (J == 1 && K == 1)
            Q <= ~Q; // toggle
        // if J=0 and K=0, Q remains unchanged
    end
endmodule