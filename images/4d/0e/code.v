module top_module(
    input D,
    input CLK,
    input SET_B,
    input RESET_B,
    output reg Q,
    output Q_N
);assign Q_N = ~Q;

    always @(posedge CLK) begin
        if (~SET_B) begin
            Q <= 1'b1;
        end else if (~RESET_B) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end

endmodule