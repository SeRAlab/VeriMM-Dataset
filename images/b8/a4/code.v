module priority_encoder_32bit (
    input wire [31:0] in,
    output wire [4:0] out
);

    wire [3:0] out_temp;
    wire valid1, valid2;

    priority_encoder_16bit encoder1 (
        .in(in[31:16]),
        .out(out_temp),
        .valid(valid1)
    );

    priority_encoder_16bit encoder2 (
        .in(in[15:0]),
        .out(out_temp),
        .valid(valid2)
    );

    assign out = valid1 ? {1'b1, out_temp} : {1'b0, out_temp};

endmodule

module priority_encoder_16bit (
    input wire [15:0] in,
    output wire [3:0] out,
    output wire valid
);

    wire [3:0] out_temp;
    wire valid1, valid2;

    priority_encoder_8bit encoder1 (
        .in(in[15:8]),
        .out(out_temp),
        .valid(valid1)
    );

    priority_encoder_8bit encoder2 (
        .in(in[7:0]),
        .out(out_temp),
        .valid(valid2)
    );

    assign out = valid1 ? {1'b1, out_temp} : {1'b0, out_temp};
    assign valid = valid1 | valid2;

endmodule

module priority_encoder_8bit (
    input wire [7:0] in,
    output wire [2:0] out,
    output wire valid
);

    assign out = (in[7]) ? 3'b111 :
                 (in[6]) ? 3'b110 :
                 (in[5]) ? 3'b101 :
                 (in[4]) ? 3'b100 :
                 (in[3]) ? 3'b011 :
                 (in[2]) ? 3'b010 :
                 (in[1]) ? 3'b001 : 3'b000;
    assign valid = |in;

endmodule