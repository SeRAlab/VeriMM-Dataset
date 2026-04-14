module top_module(wreg, m2reg, wmem, aluc, aluimm, mux, qa, qb, extend, clk,
              ewreg, em2reg, ewmem, ealuc, ealuimm, emux, eqa, eqb, eextend);input [1:0] wreg, m2reg, wmem, aluimm;
      input [3:0] aluc;
      input [4:0] mux;
      input [31:0] qa, qb, extend; 
      input clk;
      output reg [1:0] ewreg, em2reg, ewmem, ealuimm;
      output reg [3:0] ealuc;
      output reg [4:0] emux;
      output reg [31:0] eqa, eqb, eextend;

always @ (posedge clk)
begin
    ewreg = wreg;
    em2reg = m2reg;
    ewmem = wmem;
    ealuimm = aluimm;
    ealuc = aluc;
    emux = mux;
    eqa = qa;
    eqb = qb;
    eextend = extend;
end
            
endmodule