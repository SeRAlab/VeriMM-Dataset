module ring_counter(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [15:0] ring_out
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ring_out <= 16'b0000000000000001;
    end else if (en) begin
        ring_out <= {ring_out[14:0], ring_out[15]};
    end
end

endmodule