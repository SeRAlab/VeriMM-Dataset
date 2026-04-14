module top_module(
    input [2:0] in_vec1,
    input [2:0] in_vec2,
    input sel_b1,
    input sel_b2,
    output [2:0] out_vec,
    output even_parity
);wire [2:0] mux_out;
    wire [2:0] rev_in_vec;
    wire even_parity1, even_parity2;

    // 2-to-1 mux implementation
    assign mux_out = sel_b2 ? {in_vec2[2], in_vec2[1], in_vec2[0]} : {in_vec1[2], in_vec1[1], in_vec1[0]};

    // Reverse parity module implementation
    reg [2:0] shift_reg;
    wire xor_out1, xor_out2, xor_out3;

    assign even_parity1 = xor_out1 ^ xor_out2 ^ xor_out3;
    assign even_parity2 = xor_out1 ^ xor_out2 ^ xor_out3 ^ 1'b1;

    always @(posedge sel_b1) begin
        shift_reg <= sel_b2 ? {in_vec2[2], in_vec2[1], in_vec2[0]} : {in_vec1[2], in_vec1[1], in_vec1[0]};
    end

    assign rev_in_vec = shift_reg;

    assign xor_out1 = rev_in_vec[0] ^ rev_in_vec[1];
    assign xor_out2 = rev_in_vec[1] ^ rev_in_vec[2];
    assign xor_out3 = rev_in_vec[2] ^ rev_in_vec[0];

    assign out_vec = even_parity1 ? {rev_in_vec, 1'b1} : {mux_out, 1'b1};
    assign even_parity = even_parity2;

endmodule