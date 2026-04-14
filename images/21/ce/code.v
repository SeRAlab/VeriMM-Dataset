module mux4to1 (
    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [1:0] sel,
    output reg [31:0] data_out
);

always @(*) begin
    case(sel)
        2'b00: data_out = data0;
        2'b01: data_out = data1;
        2'b10: data_out = data2;
        2'b11: data_out = data3;
        default: data_out = 32'b0;
    endcase
end

endmodule