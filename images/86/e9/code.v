module top_module(
    input clk,
    input load,
    input serial_in,
    output reg [2:0] out
);always @(posedge clk) begin
        if (load) begin
            out <= serial_in;
        end else begin
            out <= {out[1:0], serial_in};
        end
    end

endmodule