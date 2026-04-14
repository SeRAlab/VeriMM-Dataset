module falling_edge_capturer_28bit(
    input clk,
    input reset,
    input [27:0] in,
    output reg [27:0] out);

    reg [27:0] in_last;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 28'b0;
        else begin
            in_last <= in;
            out <= out | (in_last & ~in);
        end
    end
endmodule