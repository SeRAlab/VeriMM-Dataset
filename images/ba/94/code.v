module ring_counter (
    input clk,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (q == 5'b00000) begin
        q <= 5'b00001;
    end else begin
        q <= {q[3:0], q[4]};
    end
end

endmodule