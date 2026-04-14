module ring_counter(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [3:0] ring
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        ring <= 4'b0001;
    end else if (en) begin
        ring <= {ring[2:0], ring[3]};
    end
end

endmodule