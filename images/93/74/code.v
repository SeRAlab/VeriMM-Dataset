module top_module(
    input [3:0] in,
    output reg [1:0] pos,
    output reg zero_flag
);wire [3:0] inv_in;
wire [3:0] and_out;
wire [1:0] mux_out;

assign inv_in = ~in;
assign and_out = inv_in & (in + 1);
assign mux_out = {and_out[3], and_out[2]} ? 2'b10 :
                {and_out[1], and_out[0]} ? 2'b01 :
                2'b00;

always @(*) begin
    if (in == 0) begin
        zero_flag = 1;
        pos = 2'b00;
    end else begin
        zero_flag = 0;
        pos = mux_out;
    end
end

endmodule