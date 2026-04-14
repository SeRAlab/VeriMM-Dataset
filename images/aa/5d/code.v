module falling_edge_detector(
    input clk,
    input reset,
    input [3:0] in,
    output reg [3:0] out);

    reg [3:0] in_d;
    
    always @(posedge clk) begin
        if (reset)
            out <= 4'b0;
        else begin
            in_d <= in;
            out <= out | (in_d & ~in);
        end
    end
endmodule