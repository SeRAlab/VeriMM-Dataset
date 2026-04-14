module T_latch (
    input wire T,
    input wire CLK,
    input wire R,
    output reg Q
);
    always @(posedge CLK or posedge R) begin
        if (R) begin
            Q <= 0;
        end else if (T) begin
            Q <= ~Q;
        end
    end
endmodule