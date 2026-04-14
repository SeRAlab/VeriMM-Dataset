module top_module(address,data,read_signal,write_signal,dataout,clk,RST, doneRead, doneWrite);input read_signal,write_signal,clk,RST;
input[15:0] data;
output[15:0] dataout;
input[15:0] address;
reg[15:0] temp;
reg[15:0] mem[0:62768];
output doneRead;
integer done_read=0;
integer done_write=0;
output doneWrite;
integer i;
always @(negedge clk) begin
    i=0;
    if (RST == 1) begin
    
    end

    else if(read_signal == 1) begin
                
        
        temp = mem[address];
        done_read=1;
    end
    else if (write_signal == 1) begin
           

        mem[address] = data;
        done_write=1;
    end

end
assign doneRead = done_read;
assign doneWrite = done_write;

    


assign dataout = temp;
endmodule