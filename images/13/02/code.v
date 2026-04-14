module T_latch (
    input T,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T)
            Q <= ~Q;  // Toggle Q if T is high
    end
endmodule