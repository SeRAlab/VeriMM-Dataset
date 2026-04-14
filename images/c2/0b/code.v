module counter(clk, reset, q);
    input clk, reset;
    output reg [3:0] q;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000;
        end
        else begin
            q <= q + 1;
        end
    end
endmodule