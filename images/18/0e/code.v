module mux_4to1 (
    input [15:0] data_in0,
    input [15:0] data_in1,
    input [15:0] data_in2,
    input [15:0] data_in3,
    input [1:0] sel,
    output reg [15:0] data_out
);

always @(*) begin
    case(sel)
        2'b00: data_out = data_in0;
        2'b01: data_out = data_in1;
        2'b10: data_out = data_in2;
        2'b11: data_out = data_in3;
        default: data_out = 16'b0;
    endcase
end

endmodule