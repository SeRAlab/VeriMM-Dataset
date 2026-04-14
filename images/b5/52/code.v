module shiftreg (
    input [3:0] data_in,
    input shift_load,
    input clk,
    output reg [3:0] data_out
);always @(posedge clk) begin
    if (shift_load) begin
        data_out <= data_in;
    end else begin
        data_out <= {1'b0, data_out[3:1]};
    end
end

endmodule