module top_module(
    input rst,
    input [7:0] addr,
    output [7:0] instrcode
    );reg [7:0] mem[255:0];
    assign instrcode =  mem[addr];
  
    always@(posedge rst)
    begin
        if(rst==1)
        begin
            mem[0]=8'h1b;
            mem[1]=8'h73;
            mem[2]=8'h4e;
            mem[3]=8'hc5;
            mem[4]=8'h0c;
            mem[5]=8'h59;
        end
    end    
endmodule