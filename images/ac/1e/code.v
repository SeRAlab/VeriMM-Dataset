module ring_counter(
    input wire clk,
    input wire rst,
    output reg [2:0] ring_out
);

always @(posedge clk) begin
    if (rst) begin
        ring_out <= 3'b001;
    end else begin
        ring_out <= {ring_out[1:0], ring_out[2]};
    end
end

endmodule