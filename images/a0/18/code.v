module top_module(
    input [3:0] data_in,
    input load,
    input clk,
    output reg [3:0] q
);always @(posedge clk) begin
        if (load) begin
            q <= data_in;
        end else begin
            q <= {q[2:0], q[3]};
        end
    end

endmodule