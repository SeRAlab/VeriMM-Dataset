module dual_edge_detector(
    input clk,
    input reset,
    input [5:0] in,
    output reg [5:0] out);

    reg [5:0] in_last;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 6'b0;
        else begin
            in_last <= in;
            out <= out | ((in & ~in_last) | (~in & in_last));
        end
    end
endmodule