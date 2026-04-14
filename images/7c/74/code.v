module top_module(
    input D,
    input Clk,
    input reset,
    input ce,
    output reg Q
    );always @(posedge Clk) begin
        if (reset) begin
            Q <= 1'b0;
        end
        else if (ce) begin
            Q <= D;
        end
    end
endmodule