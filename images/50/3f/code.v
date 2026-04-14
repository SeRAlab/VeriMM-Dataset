module top_module(clk,read,enable_RW,address,data_in,data_out);parameter DATA_WIDTH=8;
    parameter ADDRESS_WIDTH=24;
    parameter RAM_DEPTH=(2**(ADDRESS_WIDTH-2));
    
    
    input clk;
    input read;
    input enable_RW;
    input [ADDRESS_WIDTH-1:0] address;
    input [DATA_WIDTH-1:0] data_in;
    output reg[DATA_WIDTH-1:0] data_out;
    
    
    reg[7:0] mem [0:RAM_DEPTH-1];
    

    always@(posedge clk)
    begin
       if(enable_RW)
       begin
            if(read)
            begin
                data_out<=mem[address[23:2]];
            end
            else
            begin
                mem[address[23:2]]<=data_in;
            end
       end
    end

endmodule