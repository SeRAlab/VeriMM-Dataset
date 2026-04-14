module Counter_12_en_sync_rst(
   input                clk,
   input                rst,
   input                en,
   output reg [11:0]    Q  
);
    always@(posedge clk)begin
        if(rst) Q <= 12'd0;
        else if(en) Q <= Q + 1;
    end
endmodule