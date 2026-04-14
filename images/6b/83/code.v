module top_module(
    input Clk,D,reset,
    output reg Q
    );always @(posedge Clk)
    if (reset)
        begin
        Q <= 1'b0;
        end 
    else
    begin
        Q <= D;
    end
endmodule