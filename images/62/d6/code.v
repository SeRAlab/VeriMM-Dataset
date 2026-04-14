module top_module(
input updown,
input inc,
input clk,
input reset,
output reg [3:0] Q
);always @ (posedge clk)
    begin
        if (reset)
            Q <= 4'b0000;
        else
            if (updown)
                if(inc)
                    Q <= Q-2;
                else
                    Q <= Q-1;
            else
                if(inc)
                    Q <= Q+2;
                else
                    Q <= Q+1;
    end
endmodule