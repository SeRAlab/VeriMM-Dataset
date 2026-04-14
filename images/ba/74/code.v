module top_module(
    input [63:0] in,
    input [3:0] sel,
    input [3:0] comp_val,
    output out
);reg [3:0] selected_input;

always @(*) begin
    case(sel)
        0: selected_input = in[3:0];
        1: selected_input = in[7:4];
        2: selected_input = in[11:8];
        3: selected_input = in[15:12];
        4: selected_input = in[19:16];
        5: selected_input = in[23:20];
        6: selected_input = in[27:24];
        7: selected_input = in[31:28];
        8: selected_input = in[35:32];
        9: selected_input = in[39:36];
        10: selected_input = in[43:40];
        11: selected_input = in[47:44];
        12: selected_input = in[51:48];
        13: selected_input = in[55:52];
        14: selected_input = in[59:56];
        15: selected_input = in[63:60];
    endcase
end

assign out = (selected_input == comp_val) ? 1'b1 : 1'b0;

endmodule