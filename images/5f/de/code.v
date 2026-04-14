module top_module(
    q,cout,reset, cin, clk
);parameter N = 4;
    output reg [N:1]q;
    output cout;
    input reset, cin, clk;
    always @(posedge clk) 
    begin
        q <= reset ? 0 : q + cin;
    end
    assign cout = &q && cin;endmodule