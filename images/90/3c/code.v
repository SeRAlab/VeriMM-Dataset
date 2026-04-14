module top_module(datain, dataout, clk);input[16 - 1:0] datain; 
    output[16 - 1:0] dataout; 
    wire[16 - 1:0] dataout;
    input clk; 

    reg[16 - 1:0] buff0; 
    reg[16 - 1:0] buff1; 
    reg[16 - 1:0] buff2; 
    reg[16 - 1:0] buff3; 
    reg[16 - 1:0] buff4; 
    reg[16 - 1:0] buff5; 
    reg[16 - 1:0] buff6; 
    reg[16 - 1:0] buff7; 
    reg[16 - 1:0] buff8; 
    reg[16 - 1:0] buff9; 
    reg[16 - 1:0] buff10; 
    reg[16 - 1:0] buff11; 
    reg[16 - 1:0] buff12; 
    reg[16 - 1:0] buff13; 
    reg[16 - 1:0] buff14; 
    reg[16 - 1:0] buff15; 
    reg[16 - 1:0] buff16; 
    reg[16 - 1:0] buff17; 
    reg[16 - 1:0] buff18; 
    reg[16 - 1:0] buff19; 
    reg[16 - 1:0] buff20; 
    reg[16 - 1:0] buff21; 
    reg[16 - 1:0] buff22; 
    reg[16 - 1:0] buff23; 
    reg[16 - 1:0] buff24; 
    reg[16 - 1:0] buff25; 
    reg[16 - 1:0] buff26; 
    reg[16 - 1:0] buff27; 
    reg[16 - 1:0] buff28; 
    reg[16 - 1:0] buff29; 
    reg[16 - 1:0] buff30; 
    reg[16 - 1:0] buff31; 
    reg[16 - 1:0] buff32; 
    reg[16 - 1:0] buff33; 
    reg[16 - 1:0] buff34; 
    reg[16 - 1:0] buff35; 
    reg[16 - 1:0] buff36; 

 
    assign dataout = buff36 ;

    always @(posedge clk)
    begin

       buff0 <= datain ; 
		buff1 <= buff0;
		buff2 <= buff1;
		buff3 <= buff2;
		buff4 <= buff3;
		buff5 <= buff4;
		buff6 <= buff5;
		buff7 <= buff6;
		buff8 <= buff7;
		buff9 <= buff8;
		buff10 <= buff9;
		buff11 <= buff10;
		buff12 <= buff11;
		buff13 <= buff12;
		buff14 <= buff13;
		buff15 <= buff14;
		buff16 <= buff15;
		buff17 <= buff16;
		buff18 <= buff17;
		buff19 <= buff18;
		buff20 <= buff19;
		buff21 <= buff20;
		buff22 <= buff21;
		buff23 <= buff22;
		buff24 <= buff23;
		buff25 <= buff24;
		buff26 <= buff25;
		buff27 <= buff26;
		buff28 <= buff27;
		buff29 <= buff28;
		buff30 <= buff29;
		buff31 <= buff30;
		buff32 <= buff31;
		buff33 <= buff32;
		buff34 <= buff33;
		buff35 <= buff34;
		buff36 <= buff35;
    end 
 endmodule