module top_module(d, Clk, Rst, q);parameter DATAWIDTH = 8;

    input Clk, Rst;
    input [DATAWIDTH - 1:0] d;
    
    output reg [DATAWIDTH - 1:0] q;
    
    always @(posedge Clk) begin
        if(Rst)
            q <= 0;
        else
            q <= d;
    end
    
endmodule