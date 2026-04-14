module top_module( clk, set, d, q );input clk;
    input set;
    input [5:0] d;
    output [5:0] q;
    reg [5:0] q;

    always @(posedge clk or posedge set) begin
        if (set) begin
            q <= 6'b111111;
        end else begin
            q <= d;
        end
    end
endmodule