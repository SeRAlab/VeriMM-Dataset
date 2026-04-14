module top_module(
  input logic [7:0] li,
  output logic [2:0] addr_lo,
  output logic v_lo
);logic [7:0] li_not;
  logic [7:0] li_shifted;
  logic [3:0] addr_hi;
  logic [3:0] addr_hi_not;
  logic [3:0] addr_hi_shifted;
  logic [1:0] addr_hi_or;
  logic [1:0] addr_hi_and;
  logic [2:0] addr_lo_or;
  logic [2:0] addr_lo_and;

  // Complement the input
  assign li_not = ~li;

  // Find the highest bit in the input
  assign addr_hi[3] = li_not[7];
  assign addr_hi[2] = li_not[6];
  assign addr_hi[1] = li_not[5];
  assign addr_hi[0] = li_not[4];
  assign addr_hi_not = ~addr_hi;
  assign addr_hi_shifted[2] = addr_hi_not[3];
  assign addr_hi_shifted[1] = addr_hi_not[2];
  assign addr_hi_shifted[0] = addr_hi_not[1];
  assign addr_hi_or = addr_hi_shifted[1:0] | addr_hi_shifted[2:1];
  assign addr_hi_and = addr_hi_shifted[1:0] & addr_hi_shifted[2:1];

  // Find the valid bit and the address
  assign v_lo = |li;
  assign li_shifted[6:0] = li[7:1];
  assign addr_lo_or = {addr_hi_and, addr_hi_or[0]};
  assign addr_lo_and = {addr_hi_and, addr_hi_or[1]};
  assign addr_lo[2] = addr_lo_or[1] & li[7];
  assign addr_lo[1] = addr_lo_and[1] & li_shifted[6];
  assign addr_lo[0] = addr_lo_and[0] & li_shifted[5];

endmodule