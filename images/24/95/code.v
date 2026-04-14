module T_latch (
    input wire T,
    input wire EN,
    output reg Q
);
    always @(posedge EN) begin
        if (T)
            Q <= ~Q; // Toggle Q if T is high
    end
endmodule