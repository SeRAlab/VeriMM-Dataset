module top_module(in1, in2, ctrl, out);input [15:0] in1, in2;
  input [2:0] ctrl;
  output reg [15:0] out;
  reg overflow;
    
  always @(in1 or in2 or ctrl)
  begin
    case(ctrl)
		3'b000: begin 
		  {overflow , out } = in1 + in2;
		  end
		3'b001: begin 
			out = in1 - in2;
		  end
        3'b010: begin 
            out = in1 | in2;
          end
        3'b011: begin 
            out = in1 < in2;
          end
        3'b100: begin 
            out = in1 << in2;
          end
        3'b101: begin 
            out = in1 >> in2;
          end
    endcase
  end
  
endmodule