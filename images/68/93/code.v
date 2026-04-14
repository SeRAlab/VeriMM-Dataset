module top_module(instr, imm, p0Addr, p1Addr, regAddr, shamt, aluOp, branchOp, regRe0, regRe1, regWe, memRe, memWe, addz, branch, jal, jr, aluSrc0, aluSrc1, ovEn, zrEn, neEn);input [15:0] instr;

  output [11:0] imm;
  output [3:0] p0Addr, p1Addr, regAddr, shamt;
  output [2:0] aluOp, branchOp;

  
  output regRe0, regRe1, regWe, memRe, memWe, addz, branch, jal, jr, aluSrc0, aluSrc1, ovEn, zrEn, neEn;
  
  
  localparam aluAdd = 3'b000;
  
  localparam aluLhb = 3'b001;
  
  localparam aluLwSw = 3'b000;

  
  assign add = instr[15:12] == 4'b0000;
  assign addz = instr[15:12] == 4'b0001;
  assign sub = instr[15:12] == 4'b0010;
  assign lw = instr[15:12] == 4'b1000;
  assign sw = instr[15:12] == 4'b1001;
  assign lhb = instr[15:12] == 4'b1010;
  assign llb = instr[15:12] == 4'b1011;
  assign branch = instr[15:12] == 4'b1100;
  assign jal = instr[15:12] == 4'b1101;
  assign jr = instr[15:12] == 4'b1110;

  assign imm = instr[11:0];

  
  assign p0Addr = lhb ? instr[11:8] : instr[7:4];

  
  assign p1Addr = (sw | lhb) ? instr[11:8] : (lw ? instr[7:4] : (llb ? 4'h0: instr[3:0]));
  
  
  assign regAddr = jal ? 4'hf:
                   instr[11:8];
  
  
  assign shamt = instr[3:0];
  
  
  assign {regRe0, regRe1} = {1'b1, 1'b1};
  
  
  assign regWe = !addz & !sw & !branch & !jr;  
  
  assign memRe = lw;
  assign memWe = sw;
  
  
  assign ovEn = add | addz | sub;
  assign zrEn = !instr[15];
  assign neEn = ovEn;

  
  assign aluSrc0 = llb | lhb; 
  assign aluSrc1 = lw | sw;
   
  assign branchOp = instr[11:9]; 
   
  
  assign aluOp = !instr[15] ? (addz ? aluAdd : instr[14:12]) : 
                lhb ?  aluLhb : 
                llb ?  aluAdd :
                3'b000; 
  
endmodule