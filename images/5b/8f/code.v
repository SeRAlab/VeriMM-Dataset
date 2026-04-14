module top_module(
    input clk,
    input wr, 
    input[31:0] in_data,
    
    output[31:0] out_data
);reg[31:0] data = 32'h00000000;
always @(posedge clk)
begin
    if(wr)
        data <= in_data;
end
assign out_data = data;
endmodule