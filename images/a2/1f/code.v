module top_module(
    input CLK,
    input D,
    input SET_B,
    output reg Q,
    output reg Q_N
);always @(posedge CLK or negedge SET_B) begin
        if (!SET_B) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end
        else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule