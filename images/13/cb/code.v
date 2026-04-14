module d_latch(
    input wire D,
    input wire C,
    output reg Q
);
    always @ (D or C) begin
        if (C) begin
            Q <= D;
        end
    end
endmodule