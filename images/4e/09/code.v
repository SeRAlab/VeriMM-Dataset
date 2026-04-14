module top_module(
    input clk,
    input valid,
    input [3:0] data_in,
    input [1:0] ctrl,
    output reg [3:0] data_out
);always @(posedge clk) begin
    if (valid) begin
        case(ctrl)
            2'b00: data_out <= ~data_in;
            2'b01: data_out <= 4'b0000;
            2'b10: data_out <= {1'b1, 2'b00, 1'b0} & data_in;
            2'b11: data_out <= {1'b0, 2'b11, 1'b1} & data_in;
        endcase
    end
end

endmodule