module top_module(
  input CLK,
  input RST_N,
  input CSYSREQ,
  output reg CACTIVE,
  output reg CSYSACK,
  output reg req_reg
);// rule scheduling signals
  wire CAN_FIRE_cSYSREQ, WILL_FIRE_cSYSREQ;

  // action method cSYSREQ
  assign CAN_FIRE_cSYSREQ = 1'd1 ;
  assign WILL_FIRE_cSYSREQ = 1'd1 ;

  // value method cSYSACK
  assign CSYSACK = req_reg ;

  // value method cACTIVE
  assign CACTIVE = 1'd1 ;

  // register req_reg
  always@(posedge CLK)
  begin
    if (RST_N == 1'b0)
      begin
        req_reg <= 1'b1;
      end
    else
      begin
        req_reg <= CSYSREQ;
      end
  end

endmodule