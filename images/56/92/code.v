module top_module(
    input [3:0] in,
    output [3:0] out,
    input rst,
    input clk  // Added clk as an input
);reg [3:0] shifted;

    always @(posedge clk) begin
        if (rst) begin
            shifted <= 0;
        end else begin
            shifted <= {in[1:0], 2'b00};
        end
    end
    
    assign out = shifted;

endmodule