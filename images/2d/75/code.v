module morphological_dilation (
    input [2:0] in_row0,
    input [2:0] in_row1,
    input [2:0] in_row2,
    output reg [2:0] out_row0,
    output reg [2:0] out_row1,
    output reg [2:0] out_row2
);
    always @(*) begin
        // Dilation operation
        out_row0[0] = in_row0[0] | in_row0[1] | in_row1[0] | in_row1[1];
        out_row0[1] = in_row0[0] | in_row0[1] | in_row0[2] | in_row1[0] | in_row1[1] | in_row1[2];
        out_row0[2] = in_row0[1] | in_row0[2] | in_row1[1] | in_row1[2];

        out_row1[0] = in_row0[0] | in_row0[1] | in_row1[0] | in_row1[1] | in_row2[0] | in_row2[1];
        out_row1[1] = in_row0[0] | in_row0[1] | in_row0[2] | in_row1[0] | in_row1[1] | in_row1[2] | in_row2[0] | in_row2[1] | in_row2[2];
        out_row1[2] = in_row0[1] | in_row0[2] | in_row1[1] | in_row1[2] | in_row2[1] | in_row2[2];

        out_row2[0] = in_row1[0] | in_row1[1] | in_row2[0] | in_row2[1];
        out_row2[1] = in_row1[1] | in_row1[2] | in_row2[1] | in_row2[2];
        out_row2[2] = in_row1[2] | in_row2[1] | in_row2[2];
    end
endmodule