module top_module(led_total,clk,num,sel,rst_n);input[27:0]led_total;
input clk,rst_n;
output reg[6:0]num;
output reg[3:0]sel;
wire[6:0]temp1,temp2,temp3,temp4;
reg [6:0]temp;
reg[1:0]cnt;
always @(posedge clk or negedge rst_n)
begin
     if(!rst_n)begin cnt<=0;end
     else begin
					if(cnt==2'd3)begin cnt<=0; end
               else begin cnt<=cnt+1;end
           end
end

assign      temp1=led_total[27:21];
assign      temp2=led_total[20:14];
assign      temp3=led_total[13:7];
assign      temp4=led_total[6:0];

always@(posedge clk)
begin
     case(cnt)
     2'b00:sel<=4'b1000;
     2'b01:sel<=4'b0100;
     2'b10:sel<=4'b0010;
     2'b11:sel<=4'b0001;
     endcase
end
always@(posedge clk)
begin
       if(cnt==2'b00)begin temp=temp1;end
      else
          begin
               if(cnt==2'b01)begin temp=temp2;end
               else begin
                         if(cnt==2'b10)begin temp=temp3;end
                         else begin temp=temp4;end
                     end
           end

      case(temp)
      7'd0:num<=7'b1111110;
      7'd1:num<=7'b0110000;
      7'd2:num<=7'b1101101;
      7'd3:num<=7'b1111001;
      7'd4:num<=7'b0110011;
      7'd5:num<=7'b1011011;
      7'd6:num<=7'b1011111;
      7'd7:num<=7'b1110000;
      7'd8:num<=7'b1111111;
      7'd9:num<=7'b1111011;
      endcase
end
endmodule