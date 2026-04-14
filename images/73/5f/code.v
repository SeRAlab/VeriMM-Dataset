module edge_detector(
    input clk,
    input reset_n,
    input [9:0] in,
    output reg [9:0] out);

    reg [9:0] in_last;
    
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n)
            out <= 10'b0;
        else begin
            in_last <= in;
            out <= out | ((in & ~in_last) | (~in & in_last));
        end
    end
endmodule