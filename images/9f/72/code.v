module top_module(notRomMIptr, EntryPoint, s_mov);input [7:0] notRomMIptr;
    output EntryPoint, s_mov;
    wire [7:0] RomMIptr;
    wire s_0, s_1, s_2, s_3, s_4, s_5, s_6, s_7, s_8, s_9, s_10, s_11, s_12, s_13, s_14, s_15, s_16, s_dyadic, s_sqrt, s_cmp, s_conv;

    // Inverters
    assign RomMIptr[0] = ~notRomMIptr[0];
    assign RomMIptr[1] = ~notRomMIptr[1];
    assign RomMIptr[2] = ~notRomMIptr[2];
    assign RomMIptr[3] = ~notRomMIptr[3];
    assign RomMIptr[4] = ~notRomMIptr[4];
    assign RomMIptr[5] = ~notRomMIptr[5];
    assign RomMIptr[6] = ~notRomMIptr[6];
    assign RomMIptr[7] = ~notRomMIptr[7];

    // Logic gates
    assign s_0 = ~(RomMIptr[7] | RomMIptr[1] | RomMIptr[0]);
    assign s_1 = ~(RomMIptr[4] & RomMIptr[3]);
    assign s_2 = ~(RomMIptr[6] & RomMIptr[2]);
    assign s_4 = ~(RomMIptr[7] | RomMIptr[3] | RomMIptr[2] | RomMIptr[1]);
    assign s_5 = RomMIptr[6] & RomMIptr[0];
    assign s_6 = ~(RomMIptr[7] | RomMIptr[6] | RomMIptr[0]);
    assign s_3 = RomMIptr[4] ^ RomMIptr[5];
    assign s_dyadic = s_0 ^ s_3;
    assign s_sqrt = ~(s_4 & s_5 & s_3);
    assign s_cmp = ~(s_6 & s_7 & s_3);
    
    assign s_7 = RomMIptr[3] & RomMIptr[1];
    assign s_8 = ~(RomMIptr[6] | RomMIptr[5] | RomMIptr[1]);
    assign s_10 = ~(RomMIptr[4] | RomMIptr[2] | RomMIptr[1]);
    assign s_12 = ~(RomMIptr[6] | RomMIptr[2]);
    
    assign s_9 = ~(s_8 & RomMIptr[2]);
    assign s_11 = ~(s_10 & RomMIptr[6]);
    assign s_13 = ~(s_12 & s_3 & RomMIptr[1]);
    
    assign s_14 = ~(s_13 & s_11 & s_9);
    assign s_conv = ~(notRomMIptr[0] & s_14 & RomMIptr[3] & RomMIptr[7]);
    
    assign s_mov = ~(s_dyadic & s_sqrt & s_cmp);
    
    assign EntryPoint = (notRomMIptr == 8'b00000000) ? 1'b1 : 1'b0;
endmodule