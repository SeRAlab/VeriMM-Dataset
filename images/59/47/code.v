module priority_encoder_16bit (
    input wire [15:0] in,
    output wire [3:0] pos,
    output wire valid
);

    wire [1:0] pos0, pos1, pos2, pos3;
    wire valid0, valid1, valid2, valid3;

    priority_encoder4 priority_encoder4_inst0 (
        .in(in[3:0]),
        .pos(pos0),
        .valid(valid0)
    );

    priority_encoder4 priority_encoder4_inst1 (
        .in(in[7:4]),
        .pos(pos1),
        .valid(valid1)
    );

    priority_encoder4 priority_encoder4_inst2 (
        .in(in[11:8]),
        .pos(pos2),
        .valid(valid2)
    );

    priority_encoder4 priority_encoder4_inst3 (
        .in(in[15:12]),
        .pos(pos3),
        .valid(valid3)
    );

    assign valid = valid3 | valid2 | valid1 | valid0;

    assign pos = valid3 ? {2'b11, pos3} :
                 valid2 ? {2'b10, pos2} :
                 valid1 ? {2'b01, pos1} :
                 {2'b00, pos0};

endmodule

module priority_encoder4 (
    input wire [3:0] in,
    output wire [1:0] pos,
    output wire valid
);
    assign valid = |in;
    assign pos = (in[3] ? 2'b11 :
                  in[2] ? 2'b10 :
                  in[1] ? 2'b01 :
                  2'b00);
endmodule