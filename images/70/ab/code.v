module falling_edge_capturer_20bit(
    input clk,
    input reset_n,
    input [19:0] in,
    output reg [19:0] out);

    reg [19:0] in_last;
    
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            out <= 20'b0;
        else begin
            in_last <= in;
            out <= out | (in_last & ~in);
        end
    end
endmodule