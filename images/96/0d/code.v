module UpDown_counter_8_en(
   input                clk,
   input                rst_n,
   input                up_down,
   input                en,
   output reg [7:0]     Q  
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 8'd0;
        else if(en) begin
            if(up_down) Q <= Q + 1;
            else Q <= Q - 1;
        end
    end
endmodule