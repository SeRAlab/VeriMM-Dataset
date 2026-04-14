module edge_detector(
    input clk,
    input in,
    
    output reg out
);
    reg in_d;
    
    always @(posedge clk) begin
        in_d <= in;
        out <= in & ~in_d;
    end
endmodule