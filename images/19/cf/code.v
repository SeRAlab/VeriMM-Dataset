module T_flip_flop (
    input wire T,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (T) begin
            Q <= ~Q; // Toggle Q if T is high
        end
    end
endmodule