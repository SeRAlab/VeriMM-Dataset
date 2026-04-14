module top_module(
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [4:0] out
);reg [3:0] mux_out;
reg parity;

always @* begin
    case (sel)
        3'b000: mux_out = {data1, data0};
        3'b001: mux_out = {data3, data2};
        3'b010: mux_out = {data5, data4};
        default: mux_out = 4'b0;
    endcase
    
    parity = mux_out[0] ^ mux_out[1] ^ mux_out[2] ^ mux_out[3];
    out = {mux_out, parity};
end

endmodule