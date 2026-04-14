module top_module(
    input D,
    input EN,
    input RST,
    output reg Q,
    output reg Qbar
);always @ (posedge EN or negedge RST) begin
        if (RST == 0) begin
            Q <= 0;
            Qbar <= 1;
        end else if (EN == 1) begin
            Q <= D;
            Qbar <= ~D;
        end
    end

endmodule