module top_module(BusImm, Imm26, Ctrl);output [63:0] BusImm;
  input [25:0] Imm26;
  input [2:0] Ctrl;

  
  reg [63:0] BusImm;

  always @(*)   begin

        case (Ctrl)
        
        3'b000:    BusImm <= {{52{1'b0}}, Imm26[21:10]};

        
        3'b001:    BusImm <= {{55{Imm26[20]}}, Imm26[20:12]};

        
        3'b010:    BusImm <= {{38{Imm26[25]}}, Imm26[25:0]};

        
        3'b011:    BusImm <= {{45{Imm26[23]}}, Imm26[23:5]};

        
        3'b100:     BusImm <= {{48{1'b0}}, Imm26[20:5]};
        endcase
    end
endmodule