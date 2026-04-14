module top_module(
    input D,
    input RESET_B,
    input CLK,
    output reg Q,
    output reg Q_B
);always @(posedge CLK, negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 0;
            Q_B <= 1;
        end else begin
            Q <= D;
            Q_B <= ~D;
        end
    end

endmodule