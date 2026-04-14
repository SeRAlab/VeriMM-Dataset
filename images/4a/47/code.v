module top_module(clk, a, a_old, b);input wire clk;
    input wire a;

    output reg a_old = 0;
    output reg b = 1;
    wire assertion = (a_old != b);

    always @(posedge clk) begin
        a_old <= a;
        b <= !a;
        assert(a_old == b);  
    end
endmodule