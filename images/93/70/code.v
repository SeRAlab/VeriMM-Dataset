module top_module( 
    input wire [31:0] in,
    output wire [7:0] out_lo,
    output wire [7:0] out_hi,
    output wire [7:0] out_and );// Split input into 2-byte words
    wire [15:0] in_words [1:16];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : split_words
            assign in_words[i+1] = in[16*i +: 16];
        end
    endgenerate

    // Extract lower and upper bytes from each word
    wire [7:0] lo_bytes [1:16];
    wire [7:0] hi_bytes [1:16];
    generate
        for (i = 0; i < 16; i = i + 1) begin : extract_bytes
            assign lo_bytes[i+1] = in_words[i+1][7:0];
            assign hi_bytes[i+1] = in_words[i+1][15:8];
        end
    endgenerate

    // Output lower and upper bytes
    assign out_lo = {lo_bytes[1], lo_bytes[2], lo_bytes[3], lo_bytes[4], lo_bytes[5], lo_bytes[6], lo_bytes[7], lo_bytes[8]};
    assign out_hi = {hi_bytes[1], hi_bytes[2], hi_bytes[3], hi_bytes[4], hi_bytes[5], hi_bytes[6], hi_bytes[7], hi_bytes[8]};

    // Bitwise-and of lower and upper bytes
    wire [7:0] and_result [1:8];
    generate
        for (i = 0; i < 8; i = i + 1) begin : and_operation
            assign and_result[i+1] = lo_bytes[2*i+1] & hi_bytes[2*i+1];
        end
    endgenerate

    // Output result of bitwise-and operation
    assign out_and = {and_result[1], and_result[2], and_result[3], and_result[4], and_result[5], and_result[6], and_result[7], and_result[8]};

endmodule