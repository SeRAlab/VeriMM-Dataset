module top_module(
    input clk,
    input rst,
    input load,
    input [3:0] data_in,
    input shift,
    output reg [3:0] data_out
);always @ (posedge clk or negedge rst) begin
    if (~rst) begin
        data_out <= 0;
    end else if (load) begin
        data_out <= data_in;
    end else if (shift) begin
        data_out <= {data_out[2:0], 1'b0};
    end
end

endmodule