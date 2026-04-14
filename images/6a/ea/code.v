module ring_counter_3bit (
    input clk,
    input rst,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 3'b001;
    end else begin
        q <= {q[1:0], q[2]};
    end
end

endmodule