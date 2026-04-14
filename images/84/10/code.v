module top_module(clk,alu_op,func,ALU_operation);input clk;
    input[1:0] alu_op;
    input[5:0] func;
    output reg[2:0] ALU_operation;
    always@(alu_op,func)begin
      if(alu_op == 2'b00) ALU_operation = 3'b010;
      if(alu_op == 2'b01) ALU_operation = 3'b110;
      if(alu_op == 2'b11) ALU_operation = 3'b000;
      if(alu_op == 2'b10) begin
        if(func == 6'b100000) ALU_operation = 3'b010;
        if(func == 6'b100010) ALU_operation = 3'b110;
        if(func == 6'b100100) ALU_operation = 3'b000;
        if(func == 6'b100101) ALU_operation = 3'b001;
        if(func == 6'b101010) ALU_operation = 3'b111;
      end
    end

endmodule