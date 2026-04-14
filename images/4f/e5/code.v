module top_module(
    output reg Q,
    input D,
    input C,
    input S,
    input R
);parameter [0:0] INIT = 1'b0;
    initial Q = INIT;
    always @ (posedge C) begin
        if (R) begin
            Q <= 1'b0;
        end else if (S) begin
            Q <= 1'b1;
        end else begin
            Q <= D;
        end
    end
endmodule