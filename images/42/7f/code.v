module top_module(
    input wire [3:0] x,
    input wire s,
    output reg [6:0] a_to_g,
    output reg [3:0] an=4'b1111,
    output wire dp
    );reg [3:0] digit;
    assign dp=1;
    
    always@*
       begin
          if(x>=4'b1010)
             begin 
                   case(s)
                   0:        begin  digit<=x-4'b1010;  an<=4'b1110;  end
                   1:        begin  digit<=1;          an<=4'b1101;  end
                   default:  begin  digit<=0;          an<=4'b1111;  end
                   endcase
             end
          else 
             begin 
             digit<=x;an=4'b1110;
             end
       end

    
    always@*
      case(digit)
    0: a_to_g=7'b0000_001;
    1: a_to_g=7'b1001_111;
    2: a_to_g=7'b0010_010;
    3: a_to_g=7'b0000_110;
    4: a_to_g=7'b1001_100;
    5: a_to_g=7'b0100_100;
    6: a_to_g=7'b0100_000;
    7: a_to_g=7'b0001_111;
    8: a_to_g=7'b0000_000;
    9: a_to_g=7'b0000_100;
    default: a_to_g=7'b0000_001;
    endcase
endmodule