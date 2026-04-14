module subtractor_4bit(a, b, bin, diff, bout);

    input [3:0] a;
    input [3:0] b;
    input bin;
    output [3:0] diff;
    output bout;
    reg [4:0] temp;

    always @(a or b or bin)
    begin
        temp = a - b - bin;
        diff = temp[3:0];
        bout = temp[4];
    end

endmodule