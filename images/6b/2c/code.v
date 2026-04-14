module top_module(
    input [3:0] data_in,
    input shift,
    output reg [3:0] data_out
);always @(*) begin
    if (shift) begin
        data_out = {data_in[2:0], 1'b0};
    end
    else begin
        data_out = data_in;
    end
end

endmodule