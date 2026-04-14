module rising_edge_detector(
    input clk,
    input reset,
    input [7:0] in,
    output reg [7:0] out);

    reg [7:0] in_d;
    
    always @(posedge clk) begin
        if (reset)
            out <= 8'b0;
        else begin
            in_d <= in;
            out <= out | (~in_d & in);
        end
    end
endmodule