module subtractor_4bit(
    input [3:0] a, b, 
    input bin, 
    output [3:0] diff, 
    output bout);
    
    wire [4:0] b_out;

    full_subtractor FS0 (.a(a[0]), .b(b[0]), .bin(bin), .diff(diff[0]), .bout(b_out[0]));
    full_subtractor FS1 (.a(a[1]), .b(b[1]), .bin(b_out[0]), .diff(diff[1]), .bout(b_out[1]));
    full_subtractor FS2 (.a(a[2]), .b(b[2]), .bin(b_out[1]), .diff(diff[2]), .bout(b_out[2]));
    full_subtractor FS3 (.a(a[3]), .b(b[3]), .bin(b_out[2]), .diff(diff[3]), .bout(b_out[3]));

    assign bout = b_out[3]; 
endmodule

module full_subtractor (input a, b, bin, output diff, bout);
    assign {bout, diff} = a - b - bin;
endmodule