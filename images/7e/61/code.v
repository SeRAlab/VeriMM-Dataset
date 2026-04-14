module ring_counter (
    input clk,
    input rst,
    input en,
    output reg [4:0] ring_count);

    always @(posedge clk) begin
        if (rst) begin
            ring_count <= 5'b00001;
        end else if (en) begin
            ring_count <= {ring_count[3:0], ring_count[4]};
        end
    end
endmodule