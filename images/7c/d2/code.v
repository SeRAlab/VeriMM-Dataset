module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input [7:0] in,
    output reg [2:0] pos,
    output reg [3:0] out_sum
);// 2-to-1 Multiplexer
wire mux_out;
assign mux_out = (sel_b1 & sel_b2) ? b : ((sel_b1 | sel_b2) ? a : 0);

// Priority Encoder
reg [2:0] pos_reg;
always @* begin
    if (in[0]) pos_reg = 0;
    else if (in[1]) pos_reg = 1;
    else if (in[2]) pos_reg = 2;
    else if (in[3]) pos_reg = 3;
    else if (in[4]) pos_reg = 4;
    else if (in[5]) pos_reg = 5;
    else if (in[6]) pos_reg = 6;
    else if (in[7]) pos_reg = 7;
    else pos_reg = 0;
end
assign pos = pos_reg;

// Functional Module
always @* begin
    case (pos_reg)
        0: out_sum = mux_out + 0;
        1: out_sum = mux_out + 1;
        2: out_sum = mux_out + 2;
        3: out_sum = mux_out + 3;
        4: out_sum = mux_out + 4;
        5: out_sum = mux_out + 5;
        6: out_sum = mux_out + 6;
        7: out_sum = mux_out + 7;
        default: out_sum = 0;
    endcase
end

endmodule