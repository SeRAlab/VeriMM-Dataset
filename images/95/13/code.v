module ring_counter(
    input wire clk,
    input wire rst_n,
    output reg [11:0] q
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 12'b000000000001;
    end else begin
        q <= {q[10:0], q[11]};
    end
end

endmodule