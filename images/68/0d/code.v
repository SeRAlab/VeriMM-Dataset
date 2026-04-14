module top_module(clk_in, clk_out, divisor, enable);output clk_out;
input clk_in;
input enable;
input [22:0] divisor;

reg [22:0] count = -1;

always @(posedge clk_in)
begin
    if (enable == 1)
        begin    
        count <= count + 1;
        
        if (count >= (divisor - 1))
            begin
            count <= 0;        
            end
        end
    else
        begin
        count <= 0;
        end
end

assign clk_out = (count < divisor/2) ? 1'b1 : 1'b0;

endmodule