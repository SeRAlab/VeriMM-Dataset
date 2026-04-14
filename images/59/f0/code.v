module ring_counter (
    input clk,
    input rst,
    input en,
    output reg [5:0] ring);

    always @(posedge clk) begin
        if (rst) begin
            ring <= 6'b000001;
        end else if (en) begin
            ring <= {ring[4:0], ring[5]};
        end
    end
endmodule