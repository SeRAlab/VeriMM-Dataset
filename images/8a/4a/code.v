module top_module(
    input D,
    input CLK,
    input RESET,
    output reg Q
);always @(posedge CLK, posedge RESET) begin
        if (RESET) begin
            Q <= 0;
        end
        else begin
            Q <= D;
        end
    end

endmodule