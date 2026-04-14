module Counter_4_updown(
   input                clk,
   input                rst,
   input                en,
   input                up,
   output reg [3:0]     Q
);
    always@(posedge clk)begin
        if(rst) Q <= 4'd0;
        else if(en) begin
            if(up) Q <= Q + 1;
            else Q <= Q - 1;
        end
    end
endmodule