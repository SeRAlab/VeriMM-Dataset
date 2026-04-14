module D_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @ (D or E) begin
        if (E) begin
            Q <= D;
        end
        // else Q retains its value
    end
endmodule