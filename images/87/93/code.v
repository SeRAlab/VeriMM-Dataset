module ring_counter(
    input wire clk,
    input wire rst,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst) begin
        q <= 4'b0001;
    end else begin
        q <= {q[2:0], q[3]};
    end
end

endmodule