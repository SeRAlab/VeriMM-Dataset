module mux4to1 (
    input [15:0] data0,
    input [15:0] data1,
    input [15:0] data2,
    input [15:0] data3,
    input [1:0] select,
    output reg [15:0] out
);

always @(*) begin
    case (select)
        2'b00: out = data0;
        2'b01: out = data1;
        2'b10: out = data2;
        2'b11: out = data3;
        default: out = 16'b0;
    endcase
end

endmodule