module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input load,
    input clk,
    output reg [3:0] Q
);always @(posedge clk) begin
        if (load) begin
            Q <= {D,C,B,A};
        end else begin
            Q <= {Q[2:0], 1'b0};
        end
    end

endmodule