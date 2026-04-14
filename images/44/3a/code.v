module Reg_32_async_load(
   input                clk,
   input                rst,
   input                load,
   input  [31:0]        load_val,
   output reg [31:0]    Q
);
    always@(posedge clk or posedge rst)begin
        if(rst) Q <= 32'd0;
        else if(load) Q <= load_val;
    end
endmodule