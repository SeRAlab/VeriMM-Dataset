module top_module(
    input [3:0] data_in,
    input [1:0] select,
    input enable,
    output reg [3:0] data_out
);always @(*) begin
    case (select)
        2'b00: data_out = enable ? data_in[0] : data_out;
        2'b01: data_out = enable ? data_in[1] : data_out;
        2'b10: data_out = enable ? data_in[2] : data_out;
        2'b11: data_out = enable ? data_in[3] : data_out;
    endcase
end

endmodule