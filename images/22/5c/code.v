module D_latch (
    input wire D,
    input wire CLK,
    input wire EN,
    output reg Q
);
    always @(posedge CLK or negedge EN) begin
        if (!EN) begin
            Q <= D;
        end
    end
endmodule