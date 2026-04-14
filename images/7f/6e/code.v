module Binary_counter_8(
   input               clk,
   input               rst_n,
   input               en,
   output reg [7:0]    count
);
    
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) count <= 8'd0;
        else if(en) count <= count + 1;
    end
endmodule