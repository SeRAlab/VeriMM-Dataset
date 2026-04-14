module T_Latch (
    input wire T,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (T) begin
            Q <= ~Q; // Toggle Q
        end
        // If T is low, Q holds its state
    end
endmodule