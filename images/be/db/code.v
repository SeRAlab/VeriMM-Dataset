module top_module(
    input       D,
    input       CLK,
    input       RST, 
    output  reg Q,
    output  reg NQ
);always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Q <= 0;
            NQ <= 1;
        end else begin
            Q <= D;
            NQ <= ~D;
        end
    end

endmodule