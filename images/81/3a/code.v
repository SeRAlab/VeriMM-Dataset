module top_module(D, G, SN, Q, QN);input D, G, SN;
output [3:0] Q, QN;
reg [3:0] Q, QN;

always @ (SN or D)
    if (SN) begin
        Q <= D;
        QN <= ~D;
    end
    else if (G) begin
        Q <= D;
        QN <= ~D;
    end

endmodule