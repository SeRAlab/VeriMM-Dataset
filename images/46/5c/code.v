module top_module(clk, objective, out);input clk, objective;
    output out;
    
    wire clk, objective, out;
    reg D1, D2;
    
    always@(posedge clk)
    begin
        D1 <= objective;
        D2 <= D1;
    end
    
    assign out = D2 ^ D1;endmodule