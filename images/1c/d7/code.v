module T_latch(
    input T,
    input EN,
    output reg Q
);
    always @(posedge EN) begin
        if (T) begin
            Q <= ~Q; // Toggle
        end
    end
endmodule