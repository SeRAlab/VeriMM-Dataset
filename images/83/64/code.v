module top_module(
    input CLK,
    input J,
    input K,
    input RST,
    output reg Q,
    output reg Q_n
    );always @(posedge CLK)
    begin
        if(RST)
        begin
            Q <= 0;
            Q_n <= 1;
        end
        else if (J & K)
        begin
            Q_n <= Q;
            Q <= Q_n;
        end
        else if(J)
        begin
            Q <= 1;
            Q_n <= 0;
        end
        else if(K)
        begin
            Q <= 0;
            Q_n <= 1;
        end
    end
endmodule