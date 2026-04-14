module T_latch (
    input T,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q;
        end
    end
endmodule