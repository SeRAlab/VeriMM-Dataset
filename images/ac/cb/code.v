module top_module(
    input D,
    input CLK,
    input SET_B,
    input RESET_B,
    output reg Q,
    output reg Q_N
);always @ (posedge CLK) begin
        if (RESET_B == 1'b0) begin
            Q <= 1'b0;
        end else if (SET_B == 1'b0) begin
            Q <= 1'b1;
        end else begin
            Q <= D;
        end
    end

    always @ (posedge CLK) begin
        Q_N <= ~Q;
    end

endmodule