module top_module(D,
    Q,
    m_aclk,
    AR);output [3:0] D;
  input [3:0] Q;
  input m_aclk;
  input [0:0] AR;

  wire [0:0] AR;
  wire [3:0] Q;
  wire [3:0] Q_reg; // Changed to wire instead of using a packed attribute
  wire m_aclk;

  assign D[3:0] = Q_reg;

  // Synchronize each bit of the input signal using D flip-flops (we'll assume this is substituted for FDCE)
  // You can replace 'FDCE' with 'FD' if the async clear feature is not needed or available.
  (* KEEP = "yes" *) 
  reg [3:0] Q_reg_internal; // internal register for simulation
  always @(posedge m_aclk or posedge AR) begin
    if (AR) 
      Q_reg_internal <= 4'b0; // Active high reset
    else 
      Q_reg_internal <= Q; // Capture input on clock
  end
  
  assign Q_reg = Q_reg_internal; // output the internal register value

endmodule