module pipeline_processor(clk, reset, instr, result);  
  input clk;  
  input reset;  
  input [31:0] instr;  
  output reg [31:0] result;  
  
  reg [31:0] reg_file [0:3]; // 4 general purpose registers  
  reg [31:0] pc; // program counter  
  reg [31:0] if_id_instr;  
  reg [31:0] id_ex_a, id_ex_b;  
  reg [31:0] ex_mem_result;  
  reg [1:0] ex_mem_op; // operation type: 00-add, 01-subtract  
  
  // IF stage  
  always @(posedge clk or posedge reset) begin  
    if (reset) begin  
      pc <= 0;  
    end else begin  
      if_id_instr <= instr;  
      pc <= pc + 4;  
    end  
  end  
  
  // ID stage  
  always @(posedge clk) begin  
    id_ex_a <= reg_file[if_id_instr[25:21]]; // rs  
    id_ex_b <= reg_file[if_id_instr[20:16]]; // rt  
    ex_mem_op <= if_id_instr[31:30]; // operation code  
  end  
  
  // EX stage  
  always @(posedge clk) begin  
    case (ex_mem_op)  
      2'b00: ex_mem_result <= id_ex_a + id_ex_b; // ADD  
      2'b01: ex_mem_result <= id_ex_a - id_ex_b; // SUB  
      default: ex_mem_result <= 0;  
    endcase  
  end  
  
  // MEM stage (not used in this simple example)  
  always @(posedge clk) begin  
    result <= ex_mem_result; // write back result to output  
  end  
endmodule