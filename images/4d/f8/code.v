module top_module(BusImm, Imm26, Ctrl);output reg [63:0] BusImm;
	input [25:0] Imm26;
	input [1:0] Ctrl;
	
	always @(*)begin
	 begin
        if(Ctrl[1:0] == 2'b00) begin  
	   BusImm = {52'b0,Imm26[21:10]};
        end
        if(Ctrl[1:0] == 2'b01)begin 
           BusImm = {{55{Imm26[20]}}, Imm26[20:12]};
		end
		if(Ctrl[1:0] == 2'b10)begin 
			  BusImm = {{38{Imm26[25]}}, Imm26[25:0]};
		end
		if(Ctrl[1:0] == 2'b11)begin 
		  BusImm = {{45{Imm26[23]}}, Imm26[23:5]};
		end
		
		if(Ctrl[1:0] == 2'bxx)begin 
			  BusImm = {64'bx};
		end
	
	
      end
	end

endmodule