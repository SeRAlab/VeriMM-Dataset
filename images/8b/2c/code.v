module top_module(
    input D,
    input CLK_N,
    input SET_B,
    input RESET_B,
    output Q,
    output Q_N
);reg q;
    reg q_n;

    always @ (posedge CLK_N or negedge SET_B or negedge RESET_B) begin
        if (!SET_B) begin
            q <= 1'b1;
            q_n <= 1'b0;
        end else if (!RESET_B) begin
            q <= 1'b0;
            q_n <= 1'b1;
        end else if (CLK_N) begin
            q <= D;
            q_n <= ~D;
        end
    end

    assign Q = q;
    assign Q_N = q_n;

endmodule