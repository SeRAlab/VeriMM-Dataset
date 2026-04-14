module T_FlipFlop (
    input wire T,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q; // Toggle Q if T is high
        end
    end
endmodule