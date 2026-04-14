module four_input_mux (
    input [3:0] data_in_0,
    input [3:0] data_in_1,
    input [3:0] data_in_2,
    input [3:0] data_in_3,
    input [1:0] select,
    output reg [3:0] data_out
);

always @(*) begin
    case (select)
        2'b00: data_out = data_in_0;
        2'b01: data_out = data_in_1;
        2'b10: data_out = data_in_2;
        2'b11: data_out = data_in_3;
    endcase
end

endmodule