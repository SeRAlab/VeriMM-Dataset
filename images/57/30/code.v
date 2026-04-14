module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [255:0] in, // 256-bit input for the multiplexer
    input [7:0] sel,  // 8-bit select signal for the multiplexer
    input load,        // Load signal for the rotator
    input [1:0] ena,   // 2-bit enable signal for the rotator
    input [99:0] data, // 100-bit input data for the rotator
    output reg [1:0] q // 2-bit output from the functional module
);reg [255:0] mux_out;
reg [99:0] rot_out;

// 256-to-1 multiplexer
always @ (sel)
begin
    case (sel)
        8'b00000000: mux_out = in[0];
        8'b00000001: mux_out = in[1];
        // ...
        8'b11111110: mux_out = in[254];
        8'b11111111: mux_out = in[255];
    endcase
end

// 100-bit rotator
always @ (posedge clk)
begin
    if (reset) rot_out <= 0;
    else if (load) rot_out <= data;
    else if (ena == 2'b00) rot_out <= {rot_out[98:0], rot_out[99]};
    else if (ena == 2'b01) rot_out <= {rot_out[99], rot_out[98:0]};
end

// Functional module
always @ (mux_out, rot_out)
begin
    q <= {mux_out, rot_out} + q;
end

endmodule