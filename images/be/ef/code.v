module top_module(
           input clk ,
           input rst ,
           input en ,
           input [31: 0] PC_input ,
           output reg [31: 0] PC_output
       );always @(posedge clk or posedge rst)
begin
    if (rst) PC_output <= 0;
    else if (en) PC_output <= PC_input;
    else PC_output <= PC_output;

end

endmodule