module top_module(clk, o_clk);input clk;
    output o_clk;

    parameter N = 2;

    reg clk_p, clk_n;
    reg [30:0] counter_p, counter_n;

    assign o_clk = (N == 1)? clk:
                   (N[0])?(clk_n | clk_p) : clk_p;

    
    always@(posedge clk)begin
        if (counter_p == (N-1) ) begin
            counter_p <= 0;
        end
        else begin
            counter_p <= counter_p + 1;
        end
    end

    always @(posedge clk) begin
       if(counter_p < (N>>1))begin
            clk_p <= 1;
        end
        else begin
            clk_p <= 0;
        end
    end

    
    always@(posedge clk)begin
        if (counter_n == 0 ) begin
            counter_n <= (N-1);
        end
        else begin
            counter_n <= counter_n - 1;
        end
    end

    always @(posedge clk) begin
        if(counter_n > (N>>1))begin
            clk_n <= 1'b1;
        end
        else begin
            clk_n <= 1'b0;
        end
    end

endmodule