module sync_johnson_counter(
    input clk,
    input rst,
    output reg [7:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b0;
        end else begin
            q <= {q[6:0], ~q[7]};
        end
    end
endmodule