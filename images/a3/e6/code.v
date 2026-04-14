module top_module(
    input data_in,
    input enable,
    output reg data_out
);always @(posedge enable) begin
    if (enable) begin
        data_out <= data_in;
    end
end

endmodule