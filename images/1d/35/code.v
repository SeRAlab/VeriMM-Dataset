module T_latch (
    input wire T,
    input wire En,
    output reg Q
);
    always @(En or T) begin
        if (En) begin
            if (T) begin
                Q <= ~Q; // Toggle Q
            end
        end
    end
endmodule