module top_module(
  input CLK
, input RST
, input emit
, input onloop
, input [7:0] wcount
, input [31:0] ia
, input [31:0] ib
, input [31:0] ic
, input [31:0] k0
, input [31:0] k1
, input [31:0] k2
, output reg[31:0] o
);reg[31:0] a0, b0, c0;

wire[31:0] c1 = (c0 ^ b0) - {b0[17:0], b0[31:18]};
wire[31:0] a1 = (a0 ^ c1) - {c1[20:0], c1[31:21]};
wire[31:0] b1 = (b0 ^ a1) - {a1[6:0], a1[31:7]};
wire[31:0] c2 = (c1 ^ b1) - {b1[15:0], b1[31:16]};
wire[31:0] a2 = (a1 ^ c2) - {c2[27:0], c2[31:28]};
wire[31:0] b2 = (b1 ^ a2) - {a2[17:0], a2[31:18]};
wire[31:0] c3 = (c2 ^ b2) - {b2[7:0], b2[31:8]};

always @(posedge CLK) begin
  if (RST)
    o <= 32'b0;
  else begin
    if (emit) begin
      if (onloop)
        o <= c3;
      else
        o <= ic;
    end
  end
end

always @* begin
  case (wcount)
    8'd12: begin
      c0 <= ic + k2;
      b0 <= ib + k1;
      a0 <= ia + k0;
    end
    8'd11: begin
      c0 <= ic + k2 & 32'h00FFFFFF;
      b0 <= ib + k1;
      a0 <= ia + k0;
    end
    8'd10: begin
      c0 <= ic + k2 & 32'h0000FFFF;
      b0 <= ib + k1;
      a0 <= ia + k0;
    end
    8'd9: begin
      c0 <= ic + k2 & 32'h000000FF;
      b0 <= ib + k1;
      a0 <= ia + k0;
    end
    8'd8: begin
      c0 <= ic;
      b0 <= ib + k1;
      a0 <= ia + k0;
    end
    8'd7: begin
      c0 <= ic;
      b0 <= ib + k1 & 32'h00FFFFFF;
      a0 <= ia + k0;
    end
    8'd6: begin
      c0 <= ic;
      b0 <= ib + k1 & 32'h0000FFFF;
      a0 <= ia + k0;
    end
    8'd5: begin
      c0 <= ic;
      b0 <= ib + k1 & 32'h000000FF;
      a0 <= ia + k0;
    end
    8'd4: begin
      c0 <= ic;
      b0 <= ib;
      a0 <= ia + k0;
    end
    8'd3: begin
      c0 <= ic;
      b0 <= ib;
      a0 <= ia + k0 & 32'h00FFFFFF;
    end
    8'd2: begin
      c0 <= ic;
      b0 <= ib;
      a0 <= ia + k0 & 32'h0000FFFF;
    end
    8'd1: begin
      c0 <= ic;
      b0 <= ib;
      a0 <= ia + k0 & 32'h000000FF;
    end
  endcase
end

endmodule