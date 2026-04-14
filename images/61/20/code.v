module top_module(
    input [7:0] data_in0,
    input [7:0] data_in1,
    input [7:0] data_in2,
    input [7:0] data_in3,
    input sel0,
    input sel1,
    output reg [7:0] data_out
);always @(*) begin
    case({sel1, sel0})
        2'b00: data_out = data_in0;
        2'b01: data_out = data_in1;
        2'b10: data_out = data_in2;
        2'b11: data_out = data_in3;
    endcase
end

endmodule