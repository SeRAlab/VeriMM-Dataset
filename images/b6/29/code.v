module Shift_register_32(
   input                clk ,
   input                rst ,
   input                load,
   input [31:0]         data_in,
 
   output reg [31:0]    Q  
);
    always@(posedge clk or posedge rst)begin
        if(rst) Q <= 32'b00000000000000000000000000000000;
        else if(load) Q <= data_in;
        else Q <= Q << 1;
    end
endmodule