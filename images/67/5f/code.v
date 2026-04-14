module johnson_counter(
    input clk,
    input reset,
    output reg [1:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 2'b00;
        end else begin
            q <= {q[0], ~q[1]};
        end
    end

endmodule