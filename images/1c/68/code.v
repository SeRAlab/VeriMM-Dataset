module mux_4to1 (
    input [7:0] data0,
    input [7:0] data1,
    input [7:0] data2,
    input [7:0] data3,
    input [1:0] sel,
    output reg [7:0] mux_out
);

always @(*) begin
    case(sel)
        2'b00: mux_out = data0;
        2'b01: mux_out = data1;
        2'b10: mux_out = data2;
        2'b11: mux_out = data3;
        default: mux_out = 8'b00000000; // Default case
    endcase
end

endmodule