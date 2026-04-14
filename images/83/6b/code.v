module Counter_4_sync_rst(
   input                clk,
   input                rst,
   output reg [3:0]     Q  
);
    always@(posedge clk)begin
        if(rst) Q <= 4'd0;
        else Q <= Q + 1;
    end
endmodule