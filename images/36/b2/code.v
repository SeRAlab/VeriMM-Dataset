module mux4to1 (
    input [31:0] data0,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [1:0] select,
    output reg [31:0] mux_out
);
    always @(*) begin
        case (select)
            2'b00: mux_out = data0;
            2'b01: mux_out = data1;
            2'b10: mux_out = data2;
            2'b11: mux_out = data3;
            default: mux_out = 32'b0; // default case, although this should not happen
        endcase
    end
endmodule