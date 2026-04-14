module top_module(
    input clk,
    input rst,
    input ld,
    input si,
    output so,
    output reg [3:0] q
);always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0;
        end else if (ld) begin
            q <= si;
        end else begin
            q <= {q[2:0], si};
        end
    end

    assign so = q[3];

endmodule