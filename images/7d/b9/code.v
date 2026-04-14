module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    input F,
    output X,
    output Y
    );assign X = (A & B & C & D) | (A & B & C & E) | (A & B & D & E) | (C & D & A & E) | (C & D & B & E) | (A & B & C & F) | (A & B & D & F) | (C & D & A & F) | (C & D & B & F) | (C & D & E & F) | (A & B & E & F) | (B & D & E & F) | (A & D & E & F) | (B & C & E & F) | (A & C & E & F);
    assign Y = ~((A & B & C & D) | (A & B & C & E) | (A & B & D & E) | (C & D & A & E) | (C & D & B & E) | (A & B & C & F) | (A & B & D & F) | (C & D & A & F) | (C & D & B & F) | (C & D & E & F) | (A & B & E & F) | (B & D & E & F) | (A & D & E & F) | (B & C & E & F) | (A & C & E & F));
endmodule