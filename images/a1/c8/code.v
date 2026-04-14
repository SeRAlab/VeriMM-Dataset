module top_module(
    input t,Clk,Clear,
    output reg q,qbar
    );always @(posedge Clk or negedge Clear)
    begin
        if(Clear == 0)
        begin
            q <= 0;
            qbar <= 1;
        end
        else if(Clk == 1)
        begin
            q = q ^ t;
            qbar = ~q;
        end
    end
endmodule