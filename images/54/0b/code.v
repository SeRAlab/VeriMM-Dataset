module top_module(
    input [15:0] R,
    input [15:0] G,
    input [15:0] B,
    output reg [15:0] R_out,
    output reg [15:0] G_out,
    output reg [15:0] B_out
);reg [31:0] R_int;
    reg [31:0] G_int;
    reg [31:0] B_int;
    parameter CC1 = 298, CC2 = 100, CC3 = 516, CC4 = 298, CC5 = 516, CC6 = 208, CC7 = 298, CC8 = 409, CC9 = 128;
    parameter ScaleBit = 8;
    parameter MinThreshold = 0;
    parameter MaxThreshold = 65535;

    always @ (R or G or B)
    begin
        R_int = (R * CC1 - G * CC2 - B * CC3) >> ScaleBit;
        G_int = (-R * CC4 + G * CC5 - B * CC6) >> ScaleBit;
        B_int = (R * CC7 - G * CC8 + B * CC9) >> ScaleBit;
    end

    always @ (R_int or G_int or B_int)
    begin
        R_out = (R_int[17:16] == 2'b00) ? R_int[15:0] : (R_int[17] == 1'b1) ? MinThreshold : MaxThreshold;
        G_out = (G_int[17:16] == 2'b00) ? G_int[15:0] : (G_int[17] == 1'b1) ? MinThreshold : MaxThreshold;
        B_out = (B_int[17:16] == 2'b00) ? B_int[15:0] : (B_int[17] == 1'b1) ? MinThreshold : MaxThreshold;
    end

endmodule