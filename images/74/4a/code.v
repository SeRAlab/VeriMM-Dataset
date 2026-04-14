module top_module(
    input CLK,
    input D,
    input SET_B,
    input RESET_B,
    output reg Q,
    output reg Q_B
);always @(posedge CLK) begin
        if(RESET_B == 0) begin
            Q <= 0;
            Q_B <= 1;
        end else if(SET_B == 0) begin
            Q <= 1;
            Q_B <= 0;
        end else begin
            Q <= D;
            Q_B <= ~D;
        end
    end

endmodule