module up_counter(
   input                clk ,
   input                rst_n,
   input                load,
   input [31:0]         load_value,
 
   output reg [31:0]    count
);
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n) count <= 32'd0;
        else if(load) count <= load_value;
        else count <= count + 1;
    end
endmodule