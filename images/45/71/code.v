module top_module(
    input CK,
    input D,
    input RST,
    output reg Q,     // Changed Q to output reg
    output reg QN     // Changed QN to output reg
);always @(posedge CK or negedge RST) begin
    if (!RST) begin
        Q <= 0;
        QN <= 1;
    end else begin
        Q <= D;
        QN <= ~D;
    end
end

endmodule