module up_counter(reset, clk, q);
input reset, clk;
output [15:0] q;

reg [15:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else begin
        count <= count + 1;
    end
end

assign q = count;

endmodule