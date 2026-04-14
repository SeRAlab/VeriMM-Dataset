module top_module(input [31:0] D,
            input en, clk, rst,
            output reg [31:0] Q);always @(posedge clk, posedge rst)
begin
    if(rst)
    begin
        Q <= 32'd0;
    end
    else
    begin 
        if(en) Q <= D;
        else Q <= Q;
    end
end
endmodule