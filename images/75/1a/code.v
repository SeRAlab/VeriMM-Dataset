module top_module(C, D, Q);input   C, D;
    output  Q;
    reg     Q;

    always @ (posedge C)
    begin
        Q <= D;
    end
    endmodule