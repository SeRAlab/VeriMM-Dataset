module bin_to_bcd(
    input [3:0] bin,
    output reg [7:0] bcd
);
    always @(*) begin
        bcd = 8'd0;
        if (bin > 4'd9)
            bcd = {4'd1, bin - 4'd10};
        else
            bcd = {4'd0, bin};
    end
endmodule