module top_module(ALUOP,func,alu_control_out);input [5:0] ALUOP;
input [5:0] func;
output reg [5:0] alu_control_out;

always@(ALUOP,func)
begin
    if(ALUOP == 6'b111111)
        begin
            alu_control_out = func;
        end
    else
        begin 
            alu_control_out = ALUOP;
        end

end


endmodule