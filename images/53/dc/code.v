module rising_edge_capturer_5bit(
    input clk,
    input reset,
    input [4:0] in,
    output reg [4:0] out);

    reg [4:0] in_last;
    
    always @(posedge clk) begin
        if (reset)
            out <= 5'b0;
        else begin
            in_last <= in;
            out <= out | (~in_last & in);
        end
    end
endmodule