module JK_latch (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && !K)
            Q <= 1;
        else if (!J && K)
            Q <= 0;
        else if (J && K)
            Q <= ~Q; // toggle
    end
endmodule