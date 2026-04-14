module rtfSerialTxSim(rst,baud16,txd);
input rst;
input baud16;
output txd;
reg [9:0] buff;
reg [9:0] buf2;
reg [5:0] cnt;
reg [3:0]  bitcnt;
reg [7:0] msg [0:7];
reg [7:0] msgndx;
assign txd = buff[9];
always @(posedge baud16)
if (rst) begin
    cnt <= 6'd0;
    buff <= 10'h3FF;
    buf2 <= 10'h3ff;
    msg[0] = "H";
    msg[1] = "i";
    msg[2] = "T";
    msg[3] = "h";
    msg[4] = "e";
    msg[5] = "r";
    msg[6] = "e";
    msg[7] = " ";
    msgndx <= 4'd0; 
end
else begin
    cnt <= cnt + 6'd1;
    if (cnt==6'd15) begin
        cnt <= 6'd0;
        bitcnt <= bitcnt + 4'd1;
        if (bitcnt==4'd9) begin
            bitcnt <= 4'd0;
            buff <= buf2;
            msgndx <= msgndx + 8'd1;
            buf2 <= {1'b0,msg[msgndx],^msg[msgndx]};
        end
        else
            buff <= {buff[8:0],1'b1};
    end
end
endmodule