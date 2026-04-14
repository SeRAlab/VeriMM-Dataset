module bin2bcd_8bit#(
    parameter bin_width = 8,
    parameter bcd_width = 12
)(
    input  [bin_width-1:0]  bin  ,

    output reg [bcd_width-1:0] bcd
);

integer i;
always @(*) begin
    bcd = 0;
    for(i = bin_width-1; i >= 0; i = i - 1) begin
        if(bcd[3:0] > 4)
            bcd[3:0] = bcd[3:0] + 3;
        if(bcd[7:4] > 4)
            bcd[7:4] = bcd[7:4] + 3;
        if(bcd[11:8] > 4)
            bcd[11:8] = bcd[11:8] + 3;
        bcd = {bcd[bcd_width-2:0], bin[i]};
    end
end

endmodule