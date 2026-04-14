module T_latch (
    input T,
    input clk,
    output reg Q,
    output Qn
);
    assign Qn = ~Q;

    always @(posedge clk) begin
        if (T)
            Q <= ~Q;
    end
endmodule