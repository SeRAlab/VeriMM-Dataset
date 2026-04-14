module top_module(
    input clk, reset,
    input [7:0] d,
    output reg [7:0] q,
    output reg [7:0] qbar
    );always @(posedge clk, posedge reset) begin
        if (reset) begin
            q <= 8'b0000_0000; 
            qbar = ~q;
        end
        else begin
            q<=d; 
            qbar = ~q;
        end
    end
endmodule