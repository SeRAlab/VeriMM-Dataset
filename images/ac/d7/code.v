module ring_counter (
        input clk,
        input reset,
        output reg [4:0] ring);always @(posedge clk) begin
    if (reset)
        ring <= 5'b00001;
    else
        ring <= {ring[3:0], ring[4]};
end

endmodule