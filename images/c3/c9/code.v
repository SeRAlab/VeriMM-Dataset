module D_ff_posedge_async_reset(output Q, Qn, input rst_l, D, clk);

    reg Q_reg, Qn_reg;
    wire D_bar;
    
    assign D_bar = ~D;
    
    always @(posedge clk or negedge rst_l) begin
        if (~rst_l) begin
            Q_reg <= 1'b0;
            Qn_reg <= 1'b1;
        end
        else begin
            Q_reg <= D;
            Qn_reg <= D_bar;
        end
    end
    
    assign Q = Q_reg;
    assign Qn = Qn_reg;
    
endmodule