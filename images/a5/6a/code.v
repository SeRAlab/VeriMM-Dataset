module top_module(Aval, Bval, cin, op, ALUout, cout);input [7:0] Aval;
   input [7:0] Bval;
   input cin;
   input [1:0] op;
   output cout;
   output reg [7:0] ALUout;

   reg cout;

   always @(*) begin
      case(op)
         2'b00 : begin
            {cout, ALUout} = Aval + Bval + cin;
         end
         2'b10 : begin
            {cout, ALUout} = {1'b0, Aval & Bval};
         end
         2'b01 : begin
            {cout, ALUout} = 9'h100 ^ (Aval + Bval + 9'h001);
         end
         2'b11 : begin
            {cout, ALUout} = {1'b0, Bval > 7'h07 ? 8'b0 : Aval << Bval};
         end
         default: begin
            {cout, ALUout} = 9'h000;
         end
      endcase
   end

endmodule