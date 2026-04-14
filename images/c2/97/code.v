module rising_edge_detector (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg [31:0] prev_in;
reg [31:0] curr_in;

always @(posedge clk) begin
    if (reset) begin
        prev_in <= 32'b0;
        curr_in <= 32'b0;
    end else begin
        prev_in <= curr_in;
        curr_in <= in;
    end
end

assign out = curr_in & ~prev_in;

endmodule