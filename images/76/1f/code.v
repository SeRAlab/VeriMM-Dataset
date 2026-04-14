module rising_edge_capturer(
    input clk,
    input reset_n,
    input [11:0] in,
    output reg [11:0] out);

    reg [11:0] in_d;
    
    always @(posedge clk) begin
        if (~reset_n)
            out <= 12'b0;
        else begin
            in_d <= in;
            out <= out | (~in_d & in);
        end
    end
endmodule