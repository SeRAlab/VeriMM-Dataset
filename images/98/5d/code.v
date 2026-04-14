module top_module(
    input clk,
    input in,
    output out
    );reg delay;
always @(posedge clk)begin
    delay <= in;
end    

assign out = in | delay;
endmodule