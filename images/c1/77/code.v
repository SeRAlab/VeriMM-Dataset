module clock_seg7led_interface(
input clk,rst,
input [7:0]din,
output reg [7:0]dout,
input wr,rd ,
input [2:0]wr_addr,input [2:0]rd_addr,
output reg [7:0] seg7_sel,seg7_data
);  
reg [7:0]buff[0:3];
always @ (posedge clk)
if (wr)
buff[wr_addr] = din;
always @(posedge clk)
if (rd)
dout = buff[rd_addr] ;
else dout=0;
    reg [31:0] seg7_cntr;
    always @(posedge clk)seg7_cntr=seg7_cntr+1;
    wire  [2:0]  sel =seg7_cntr[17:15] ;  
	wire flash_bit = seg7_cntr[21];
    always @(posedge clk)
    case (sel[2:0])
        0:seg7_data=(buff[3][0]&flash_bit)?'hff:seg(buff[0][3:0]);
        1:seg7_data=(buff[3][1]&flash_bit)?'hff:seg(buff[0][3:0]);
        2:seg7_data=(buff[3][2]&flash_bit)?'hff:~8'b01000000;
        3:seg7_data=(buff[3][3]&flash_bit)?'hff:seg(buff[1][3:0]);
        4:seg7_data=(buff[3][4]&flash_bit)?'hff:seg(buff[1][3:0]);
        5:seg7_data=(buff[3][5]&flash_bit)?'hff:~8'b01000000;
        6:seg7_data=(buff[3][6]&flash_bit)?'hff:seg(buff[2][3:0]);
        7:seg7_data=(buff[3][7]&flash_bit)?'hff:seg(buff[2][3:0]);
    endcase
    always @(posedge clk) seg7_sel=~(1<<sel);
    function [7:0] seg;
        input [3:0] data;
        begin
            case(data)
                0: seg = ~8'b00111111;
                1: seg = ~8'b00000110;
                2: seg = ~8'b01011011;
                3: seg = ~8'b01001111;
                4: seg = ~8'b01100110;
                5: seg = ~8'b01101101;
                6: seg = ~8'b01111101;
                7: seg = ~8'b00000111;
                8: seg = ~8'b01111111;
                9: seg = ~8'b01101111;
                10: seg = ~8'b01110111;
                11: seg = ~8'b01111100;
                12: seg = ~8'b01011000;
                13: seg = ~8'b01011110;
                14: seg = ~8'b01111001;
                15: seg = ~8'b01110001;
            endcase
        end
    endfunction
endmodule