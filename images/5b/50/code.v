module ring_counter(
    input clk,
    input reset,
    output reg [2:0] q);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 3'b001;
        end else begin
            q <= {q[1:0], q[2]};
        end
    end

endmodule