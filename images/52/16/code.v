module top_module(
    input [3:0] binary_in,
    output [15:0] bcd_out
);reg [3:0] bcd [9:0];
    // Lookup table for BCD conversion
    initial begin
        bcd[0] = 4'b0000;
        bcd[1] = 4'b0001;
        bcd[2] = 4'b0010;
        bcd[3] = 4'b0011;
        bcd[4] = 4'b0100;
        bcd[5] = 4'b0101;
        bcd[6] = 4'b0110;
        bcd[7] = 4'b0111;
        bcd[8] = 4'b1000;
        bcd[9] = 4'b1001;
    end
    
    wire [3:0] bcd_0, bcd_1, bcd_2, bcd_3;
    
    assign bcd_0 = bcd[binary_in[3]];
    assign bcd_1 = bcd[binary_in[2]];
    assign bcd_2 = bcd[binary_in[1]];
    assign bcd_3 = bcd[binary_in[0]];
    
    assign bcd_out = {bcd_0, bcd_1, bcd_2, bcd_3};
    
endmodule