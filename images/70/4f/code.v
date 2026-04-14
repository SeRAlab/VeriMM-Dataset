module top_module(sb_ireq1, sb_ireq2, sb_ireq3, sb_ireq4,
			sav_ac, sav_io, sav_pc, sav_jmp);parameter sbs_model = "SBS";

   input sb_ireq1;
   input sb_ireq2;
   input sb_ireq3;
   input sb_ireq4;

   output [0:11] sav_ac;
   output [0:11] sav_io;
   output [0:11] sav_pc;
   output [0:11] sav_jmp;
   
   generate
      if(sbs_model == "SBS") begin
	 assign sav_ac  = 12'o0000;
	 assign sav_io  = 12'o0002;
	 assign sav_pc  = 12'o0001;
	 assign sav_jmp = 12'o0003;
      end
      else begin
	 reg [0:11] r_ac;
	 reg [0:11] r_pc;
	 reg [0:11] r_io;
	 reg [0:11] r_jmp;

	 assign sav_ac = r_ac;
	 assign sav_io = r_io;
	 assign sav_jmp = r_jmp;
	 assign sav_pc = r_pc;
	 
	 always @(sb_ireq1 or sb_ireq2 or sb_ireq3 or sb_ireq4) begin
	    case({sb_ireq1, sb_ireq2, sb_ireq3, sb_ireq4})
	      4'b1XXX:
		begin
		   r_ac  <= 12'o0000;
		   r_pc  <= 12'o0001;
		   r_io  <= 12'o0002;
		   r_jmp <= 12'o0003;
		end
	      4'bX1XX:
		begin
		   r_ac  <= 12'o0004;
		   r_pc  <= 12'o0005;
		   r_io  <= 12'o0006;
		   r_jmp <= 12'o0007;		   
		end
	      4'bXX1X:
		begin
		   r_ac  <= 12'o0010;
		   r_pc  <= 12'o0011;
		   r_io  <= 12'o0012;
		   r_jmp <= 12'o0013;		   
		end	      
	      4'bXXX1:
		begin
		   r_ac  <= 12'o0014;
		   r_pc  <= 12'o0015;
		   r_io  <= 12'o0016;
		   r_jmp <= 12'o0017;		   
		end
	      default:
		begin
		   r_ac  <= 12'o0000;
		   r_pc  <= 12'o0000;
		   r_io  <= 12'o0000;
		   r_jmp <= 12'o0000;		   
		end
	    endcase 
	 end
      end
   endgenerate
      
endmodule