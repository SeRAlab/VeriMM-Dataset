module top_module(read_reg,write_back_data,data_mem_in,sel,out);input[31:0]write_back_data,data_mem_in,read_reg;
input[1:0]sel;
output reg[31:0]out;
always@(sel,write_back_data,data_mem_in,read_reg)
begin
    if(sel == 2'b00)
    begin
        out = read_reg;
    end
    else if(sel == 2'b01)
    begin
        out = write_back_data;
    end
    else
    begin
        out = data_mem_in;
    end
end
endmodule