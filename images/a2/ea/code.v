module top_module(
    input [7:0] in,
    input [2047:0] mux_in,
    input [7:0] sel,
    input [1:0] enable,
    output reg [2:0] pos,
    output reg [7:0] out1,  // Changed to reg
    output reg [7:0] out2,  // Changed to reg
    output reg [7:0] out3,  // Changed to reg
    output reg [7:0] out4   // Changed to reg
);// Priority encoder
wire [7:0] in_priority = ~in;
wire [7:0] in_priority_shifted = {in_priority[6:0], 1'b0};
wire [7:0] in_priority_or = in_priority | in_priority_shifted;
wire [7:0] in_priority_or_shifted = {in_priority_or[5:0], 2'b0};
wire [7:0] in_priority_or_or = in_priority_or | in_priority_or_shifted;
wire [7:0] in_priority_or_or_shifted = {in_priority_or_or[3:0], 4'b0};
wire [7:0] in_priority_or_or_or = in_priority_or_or | in_priority_or_or_shifted;
wire [7:0] in_priority_or_or_or_shifted = {in_priority_or_or_or[1:0], 6'b0};
wire [7:0] in_priority_or_or_or_or = in_priority_or_or_or | in_priority_or_or_or_shifted;
assign pos = in_priority_or_or_or_or[7:5] - 1;

// Multiplexer
wire [7:0] mux_out;
assign mux_out = mux_in[sel*8 +: 8];

// Decoder
wire [3:0] enable_decoded;
assign enable_decoded = (enable == 2'b00) ? 4'b0001 :
                       (enable == 2'b01) ? 4'b0010 :
                       (enable == 2'b10) ? 4'b0100 :
                       (enable == 2'b11) ? 4'b1000 : 4'b0000;

// Output
always @(*) begin
    out1 = (enable_decoded[0]) ? mux_out : 8'b0;
    out2 = (enable_decoded[1]) ? mux_out : 8'b0;
    out3 = (enable_decoded[2]) ? mux_out : 8'b0;
    out4 = (enable_decoded[3]) ? mux_out : 8'b0;
end

endmodule