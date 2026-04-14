module top_module(master_STB, master_DAT_I, master_DAT_O, master_ACK, master_WE, master_ADDR, slave_STB, slave_ACK, slave_WE, slave_DAT_I, slave_DAT_O, slave_ADDR);input wire master_STB, master_WE;
    input wire [31: 0] master_DAT_I, master_ADDR;
    input wire [511: 0] slave_DAT_I;
    input wire [15: 0] slave_ACK;
    output wire [31: 0] master_DAT_O, slave_DAT_O, slave_ADDR;
    output reg [15: 0] slave_STB;
    output wire master_ACK, slave_WE;

    assign master_ACK = slave_ACK[master_ADDR[31: 28]];
    assign slave_DAT_O = master_DAT_I;
    assign slave_WE = master_WE;

    wire [31: 0] slaves_DAT[0: 15];

    
    assign slaves_DAT[0] = slave_DAT_I[31: 0];
    assign slaves_DAT[1] = slave_DAT_I[63: 32];
    assign slaves_DAT[2] = slave_DAT_I[95: 64];
    assign slaves_DAT[3] = slave_DAT_I[127: 96];
    assign slaves_DAT[4] = slave_DAT_I[159: 128];
    assign slaves_DAT[5] = slave_DAT_I[191: 160];
    assign slaves_DAT[6] = slave_DAT_I[223: 192];
    assign slaves_DAT[7] = slave_DAT_I[255: 224];
    assign slaves_DAT[8] = slave_DAT_I[287: 256];
    assign slaves_DAT[9] = slave_DAT_I[319: 288];
    assign slaves_DAT[10] = slave_DAT_I[351: 320];
    assign slaves_DAT[11] = slave_DAT_I[383: 352];
    assign slaves_DAT[12] = slave_DAT_I[415: 384];
    assign slaves_DAT[13] = slave_DAT_I[447: 416];
    assign slaves_DAT[14] = slave_DAT_I[479: 448];
    assign slaves_DAT[15] = slave_DAT_I[511: 480]; 

    assign master_DAT_O = slaves_DAT[master_ADDR[31: 28]];
    assign slave_ADDR = {4'b0, master_ADDR[27: 0]};

    always @* begin
        slave_STB = 0;
        slave_STB[master_ADDR[31: 28]] = master_STB;
    end

endmodule