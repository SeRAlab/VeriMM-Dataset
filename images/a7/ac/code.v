module top_module(input clkin, output reg clkout = 0);parameter load = 32'd2;
reg[31:0] count =  0;

always @(posedge clkin) begin
    count <= (count == 0) ? load - 1 : count - 1;
    clkout <= (count == 0) ? ~clkout : clkout;
end
endmodule