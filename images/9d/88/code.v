module top_module(
    input clk,    // Clocks are used in sequential circuits
    input d,
    output reg q );// Implementing the D flip-flop using NAND gates
    wire n1, n2, n3, n4;
    
    assign n1 = ~(d & clk);
    assign n2 = ~(n1 & q);
    assign n3 = ~(n2 & clk);
    assign n4 = ~(n3 & ~q);
    
    always @(posedge clk) begin
        q <= ~n4;
    end
    
endmodule