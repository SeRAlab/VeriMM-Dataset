module TFlipFlop (
    input wire T,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q; // Toggle Q
        end
    end
endmodule