module top_module(a, b, s, c);parameter N = 8;

    input wire [N-1:0] a;
    input wire [N-1:0] b;
    output wire [N-1:0] s;
    output wire c;

    wire [N:0] a_ext;
    wire [N:0] b_ext;
    wire [N:0] s_ext;

    assign a_ext = {1'b0, a};
    assign b_ext = {1'b0, b};

    assign s_ext = {N+1{1'b0}};

    assign c = 1'b0;

    genvar i;

    generate
        for (i = 0; i < N; i = i + 1) begin : add_carry_loop
            assign s_ext[i] = a_ext[i] ^ b_ext[i] ^ c;
            assign c = (a_ext[i] & b_ext[i]) | (a_ext[i] & c) | (b_ext[i] & c);
        end
    endgenerate

    assign s = s_ext[N-1:0];

endmodule