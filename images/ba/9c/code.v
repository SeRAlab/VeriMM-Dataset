module top_module(
    input wire clk,
    input wire rst,
    output reg [3:0] random
);always @(posedge clk or posedge rst) begin
        if(rst)
            random<=4'b1000;
        else begin
            random[2:0]<=random[3:1];
            random[3]<=random[1]^random[0];
        end
    end
endmodule