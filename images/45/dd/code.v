module top_module(
    input D,
    input CLK,
    input RESET,
    input EN,
    output reg Q
);always @(posedge CLK or negedge RESET) begin
        if (~RESET) begin
            Q <= 0;
        end else if (EN) begin
            Q <= D;
        end
    end

endmodule