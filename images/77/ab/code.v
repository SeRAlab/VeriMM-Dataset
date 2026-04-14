module top_module(
    input D,
    input T,
    input RN,
    input SN,
    output reg Q,
    output reg QN
    );always @ (D, T, RN, SN)
        if (RN == 0) begin
            Q <= 0;
            QN <= 1;
        end else if (SN == 0) begin
            Q <= 1;
            QN <= 0;
        end else if (T == 1) begin
            Q <= ~Q;
            QN <= ~QN;
        end else begin
            Q <= Q;
            QN <= QN;
        end
        
endmodule