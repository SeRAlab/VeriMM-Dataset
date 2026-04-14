module top_module(
    input D,
    input RESET_B,
    output Q
);reg Q_reg;

    always @(posedge D, negedge RESET_B) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end else begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;

endmodule