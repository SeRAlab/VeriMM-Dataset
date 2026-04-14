module T_latch (
    input wire T,
    input wire EN,
    output reg Q
);
    always @(posedge EN) begin
        if (T) begin
            Q <= ~Q;
        end
    end
endmodule