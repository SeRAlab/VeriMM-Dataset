module morphological_dilation (
    input [8:0] img_in, // 3x3 binary image flattened
    output reg img_out // single bit output
);
    integer i, j;
    always @(*) begin
        img_out = 0; // default output
        // Check the 3x3 area for 1's
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                if (img_in[i*3 + j] == 1) begin
                    img_out = 1; // set output if there's at least one 1
                end
            end
        end
    end
endmodule