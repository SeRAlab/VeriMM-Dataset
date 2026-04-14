module mux_4to1 (
    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [1:0] select,
    output reg [31:0] out
);
    always @(*) begin
        case (select)
            2'b00: out = data0;
            2'b01: out = data1;
            2'b10: out = data2;
            2'b11: out = data3;
            default: out = 32'b0; // Default case to avoid latches
        endcase
    end
endmodule