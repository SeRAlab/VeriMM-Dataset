module top_module(clk, din, wEn, regNum, sel, dout, npc_out, expiaddr, ins, cop_addr, cop_data);input clk;
  input [1:0] wEn;
  input [4:0] regNum;
  input [2:0] sel;
  input [31:0] din;
  input [31:0] ins;
  input [31:0] npc_out;
  output [31:0] dout;
  output reg [31:0] expiaddr;
  input [4:0] cop_addr;
  output [31:0] cop_data;

  reg [31:0] coprf [0:31];
  reg [31:0] epc;

  // Constants for opcodes and function codes
  localparam R = 6'b000000;
  localparam MTC0_MFC0_ERET = 6'b010000;
  localparam SYSCALL = 6'b001100;
  localparam MTC0 = 5'b00100;
  localparam MFC0 = 5'b00000;
  localparam ERET = 5'b10000;

  // Initialize the Status, Cause, and EPC registers
  initial begin
    coprf[12] = 32'h0000_0000; // Status
    coprf[13] = 32'h0000_0000; // Cause
    coprf[14] = 32'h0000_0000; // EPC
  end

  // Read from register file
  assign dout = coprf[regNum];

  // Read from co-processor register
  assign cop_data = coprf[cop_addr];

  // Handle write operations and system calls
  always @ (posedge clk) begin
    if (wEn == 2'b01) begin // Write to register file
      coprf[regNum] <= din;
    end else if (wEn == 2'b10) begin // Write to co-processor register
      coprf[cop_addr] <= din;
    end else if (sel == 3'b010) begin // Handle system call
      if (ins[31:0] == SYSCALL) begin // SYSCALL
        coprf[14] <= npc_out - 4'b1000;
        coprf[13][6:2] <= 5'b01000;
        coprf[12][1] <= 1'b1;
        expiaddr <= 32'h0000_0000;
      end else if ((ins[31:0] & 6'b111111) == MTC0_MFC0_ERET) begin // ERET
        coprf[12][1] <= 1'b0;
        expiaddr <= coprf[14][31:0];
      end
    end
  end
endmodule