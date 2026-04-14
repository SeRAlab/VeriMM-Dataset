module top_module(
    input clk,
    input load,
    input [3:0] in,
    output reg [3:0] out,
    output reg [3:0] out_next
);always @(posedge clk) begin
        if (load) begin
            out <= in;
            out_next <= in;
        end
        else begin
            out <= {out[2:0], out[3]};
            out_next <= {out[1:0], in};
        end
    end

endmodule