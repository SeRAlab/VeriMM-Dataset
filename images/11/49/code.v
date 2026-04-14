module TFlipFlop (
    input clk,
    input T,
    output reg Q
);
    always @(posedge clk) begin
        if (T) begin
            Q <= ~Q; // Toggle the output if T is high
        end
    end
endmodule