module top_module(
    input clk,
    input reset,
    input load,
    input [31:0] data_in,
    output reg [31:0] data_out
);always @(posedge clk or negedge reset) begin
        if (~reset) begin
            data_out <= 0;
        end else if (load) begin
            data_out <= data_in;
        end
    end

endmodule