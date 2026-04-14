module T_latch (
    input wire T,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (T)
            Q <= ~Q; // Toggle Q on T = 1
        // else Q retains its value
    end
endmodule