module d_latch (
    input wire D,
    input wire EN,
    output reg Q
);
    always @(D or EN) begin
        if (EN) begin
            Q <= D;
        end
        // else Q retains its value
    end
endmodule