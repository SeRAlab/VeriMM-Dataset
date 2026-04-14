module top_module(

    input X,
    input clk,
    input clr,
    output Y
    );reg A,B,C;

    always @(posedge(clk) or posedge(clr))
        begin
        if (clr == 1)
            begin
                A <= 1'b0;
                B <= 1'b0;
                C <= 1'b0;
            end
        else
            begin
                A <= X;
                B <= A;
                C <= ~B;
            end
       
        end
        
        assign Y = (A && B && C);

endmodule