module top_module(
    input CLK,
    input D,
    input RST,
    input EN,
    input VPWR,
    input VGND,
    output reg Q,
    output Q_N
);assign Q_N = ~Q;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 1'b0;
        end else if (EN) begin
            Q <= D;
        end
    end

endmodule