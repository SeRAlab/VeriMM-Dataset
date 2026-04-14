module top_module( 
    input a,b,c, // Binary inputs for the decoder
    input [1023:0] in, // 1024-bit input vector for the multiplexer
    input [7:0] sel, // 8-bit selection input for the multiplexer
    output [3:0] out // 4-bit final output from the functional module
);// 3:4 decoder
wire w = ~(a & b & c);
wire x = ~(a & b & ~c);
wire y = ~(a & ~b & c);
wire z = ~(a & ~b & ~c);

// Barrel shifter-based 256-to-1 multiplexer
wire [255:0] mux_out;
genvar i;
generate
    for (i = 0; i < 256; i = i + 1) begin : mux_block
        assign mux_out[i] = in[(i*4) +: 4];
    end
endgenerate
wire [3:0] mux_sel = sel[7:4];
wire [3:0] mux_out_sel;
assign mux_out_sel[0] = mux_out[mux_sel[0]];
assign mux_out_sel[1] = mux_out[mux_sel[1]];
assign mux_out_sel[2] = mux_out[mux_sel[2]];
assign mux_out_sel[3] = mux_out[mux_sel[3]];

// Adder for final output
wire [3:0] add_out;
assign add_out = w + x + y + z + mux_out_sel;

// Output
assign out = add_out;

endmodule