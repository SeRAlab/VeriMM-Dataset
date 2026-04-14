module top_module(
input [1:0] S,
input [3:0] in,
output reg [3:0] Q,
input clk,
input reset
);always @ (posedge clk)
    begin
        if (reset == 1'b1)
            Q <= 4'b0000;
        else if (S == 2'b00)
            begin
                Q[3] <= Q[3];
                Q[2] <= Q[2];
                Q[1] <= Q[1];
                Q[0] <= Q[0];
                end
        else if (S == 2'b01)
            begin
                Q[3] <= 1'b0;
                Q[2] <= Q[3];
                Q[1] <= Q[2];
                Q[0] <= Q[1];
                end
        else if (S == 2'b10)
            begin
                Q[3] <= Q[2];
                Q[2] <= Q[1];
                Q[1] <= Q[0];
                Q[0] <= 1'b0;
                end
        else if (S == 2'b11)
            begin
                Q[3] <= in[3];
                Q[2] <= in[2];
                Q[1] <= in[1];
                Q[0] <= in[0];
                end
    end


endmodule