module mux_16bit (
    input [15:0] data0,
    input [15:0] data1,
    input [15:0] data2,
    input [15:0] data3,
    input [1:0] sel,
    output reg [15:0] mux_out
);

always @(*) begin
    case (sel)
        2'b00: mux_out = data0;
        2'b01: mux_out = data1;
        2'b10: mux_out = data2;
        2'b11: mux_out = data3;
        default: mux_out = 16'b0; // default case
    endcase
end

endmodule