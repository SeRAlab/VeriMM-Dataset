module top_module(
  input  wire CLK  ,
  input  wire RST  ,
  output wire HALT  
);reg [4:0] pc;         
  reg [7:0] ac;         
  reg [7:0] mem [0:31]; 

  wire [7:0] instruction = mem[pc];
  wire [7:5] opcode      = instruction[7:5];
  wire [4:0] operand     = instruction[4:0];
  wire [7:0] rvalue      = mem[operand];

  always @(posedge CLK)
    if ( RST )
      pc <= 0 ;
    else
      case ( opcode )
        0: begin                    pc<=pc;         end 
        1: begin                    pc<=pc+1+(!ac); end 
        2: begin ac <= ac + rvalue; pc<=pc+1;       end 
        3: begin ac <= ac & rvalue; pc<=pc+1;       end 
        4: begin ac <= ac ^ rvalue; pc<=pc+1;       end 
        5: begin ac <=      rvalue; pc<=pc+1;       end 
        6: begin mem[operand]<=ac;  pc<=pc+1;       end 
        7: begin                    pc<=operand;    end 
      endcase

  assign HALT = opcode == 0;

endmodule