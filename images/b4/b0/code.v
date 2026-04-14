module top_module(
    input wire clk,
    input wire reset,
    input wire load,
    input wire [15:0] d,
    input wire si,
    output reg [15:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0000000000000000;
        end else if (load) begin
            q <= d;
        end else begin
            q <= {si, q[15:1]};
        end
    end

endmodule