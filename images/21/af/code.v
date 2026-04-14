module png_compression_check(
    input [31:0] header,
    output reg valid
);
    always @(*) begin
        if (header == 32'h89504E47) 
            valid = 1'b1; // Valid PNG header
        else 
            valid = 1'b0; // Invalid PNG header
    end
endmodule