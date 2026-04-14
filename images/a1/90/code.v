module top_module(
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);wire [1:0] sel;
assign sel = in[8];

// Decoder
wire [3:0] dec_out;
assign dec_out = (sel == 2'b00) ? 4'b0001 :
                 (sel == 2'b01) ? 4'b0010 :
                 (sel == 2'b10) ? 4'b0100 :
                                  4'b1000 ;

// Multiplexer
wire [7:0] mux_out_lo;
wire [7:0] mux_out_hi;

assign mux_out_lo = (dec_out[0]) ? in[7:0] : in[15:8];
assign mux_out_hi = (dec_out[1]) ? in[7:0] : in[15:8];

assign out_lo = mux_out_lo;
assign out_hi = mux_out_hi;

endmodule