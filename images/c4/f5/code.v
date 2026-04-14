module multiplexer_4to1 (
    input [7:0] data_in0,
    input [7:0] data_in1,
    input [7:0] data_in2,
    input [7:0] data_in3,
    input [1:0] select,
    output reg [7:0] data_out
);

always @(*) begin
    case (select)
        2'b00: data_out = data_in0;
        2'b01: data_out = data_in1;
        2'b10: data_out = data_in2;
        2'b11: data_out = data_in3;
    endcase
end

endmodule