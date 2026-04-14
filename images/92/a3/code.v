module top_module(
    input wire clk,
    input wire reset,
    input wire shift_left,
    input wire shift_right,
    input wire load,
    input wire [3:0] data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= data;
        end else if (shift_left) begin
            q <= {q[2:0], 1'b0};
        end else if (shift_right) begin
            q <= {1'b0, q[3:1]};
        end
    end

endmodule