module dff_ar (
    Q,
    CLK,
    D,
    RST
);

    output Q;
    input CLK, D, RST;

    reg Q;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule