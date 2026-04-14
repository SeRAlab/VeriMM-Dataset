module top_module(output reg [7:0] out, input [7:0] in, input ld,rshct,clk,reset);always @(posedge clk, posedge reset)
begin
    if(reset)
        out <= 0;
    else if(ld)
        out <= in;
    else if(rshct)
        out <= out >> 1;
end
endmodule