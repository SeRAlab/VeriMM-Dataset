module top_module(
    input clock,
    input reset,
    input debugEnable,
    input debugReset,
    input notEnable,
    input clear,
    input[31:0] instruction,
    input[7:0] pcNext,
    output reg[31:0] instructionOut,
    output reg[7:0] pcNextOut
);always @(negedge clock, posedge reset) begin
        if (reset) begin
            instructionOut <= 0;
            pcNextOut <= 0;
        end
        else if (debugReset) begin
            instructionOut <= 0;
            pcNextOut <= 0;
        end
        else if (~notEnable && debugEnable) begin
            if (clear) begin
                instructionOut <= 0;
            end
            else begin
                instructionOut <= instruction;
            end
            pcNextOut <= pcNext;
        end
    end

endmodule