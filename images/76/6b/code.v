module top_module(
    input [1:0] sel, // 2-bit select input for the multiplexer
    input [3:0] in, // 4-bit input for the multiplexer
    input enable, // Enable input for the decoder
    input [1:0] select, // 2-bit select input for the decoder
    output [3:0] out // 4-bit output
);// 4-input multiplexer
wire [3:0] mux_out;
assign mux_out = (sel == 2'b00) ? in[0] :
                 (sel == 2'b01) ? in[1] :
                 (sel == 2'b10) ? in[2] :
                                  in[3];

// 4-to-16 decoder
wire [15:0] decoder_out;
assign decoder_out = (enable) ? {16{select[1], select[0]}} : 16'b0;

// Functional module
assign out = (decoder_out[sel]) ? decoder_out[sel] : mux_out;

endmodule