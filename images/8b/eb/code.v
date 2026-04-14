module top_module(
                  input signed [31:0] inp,
                  input [4:0]         shamt,
                  input               isSrl,
                  output [31:0]       out
                  );assign out = (isSrl)? $signed(inp>>shamt):
                (inp>>>shamt);

endmodule