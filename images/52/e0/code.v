module top_module (
    input wire clk,
    input wire s_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        q <= {q[2:0], s_in};
    end

endmodule