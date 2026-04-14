module ring_counter(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [1:0] count
);

always @(posedge clk) begin
    if (~rst) begin
        count <= 2'b01;
    end else if (en) begin
        count <= {count[0], count[1]};
    end
end

endmodule