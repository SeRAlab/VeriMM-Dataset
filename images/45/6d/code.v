module top_module(input D, SET, RESET, CLK, output Q);reg Q_reg;

    always @(posedge CLK, posedge SET, posedge RESET)
    begin
        if (SET)
            Q_reg <= 1;
        else if (RESET)
            Q_reg <= 0;
        else
            Q_reg <= D;
    end

    assign Q = Q_reg;

endmodule