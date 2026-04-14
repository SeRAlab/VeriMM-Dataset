module parallel_load_reg(
   input                clk,
   input                rst_n,
   input                enable,
   input  [7:0]         data_in,
 
   output reg [7:0]     Q
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) Q <= 8'd0;
        else if(enable) Q <= data_in;
    end
endmodule