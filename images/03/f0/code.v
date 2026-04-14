module D_latch (
    input D,
    input CLK,
    output reg Q
);
    always @(posedge CLK or negedge CLK) begin
        if (CLK) begin
            Q <= D;
        end
        // When CLK is low, Q retains its value
    end
endmodule