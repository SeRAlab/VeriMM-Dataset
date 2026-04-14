module top_module(
               // inputs:
                address,
                clock,
                reset_n,

               // outputs:
                readdata
             )
;output  [ 31: 0] readdata;
  input            address;
  input            clock;
  input            reset_n;

  wire    [ 31: 0] readdata;
  reg     [ 31: 0] mem [0:1];

  assign readdata = mem[address][31:0];

  always @(posedge clock) begin
    if(!reset_n) begin
      mem[0][31:0] <= 32'h00000000;
      mem[1][31:0] <= 32'h51EAE681;
    end else begin
      mem[address][31:0] <= mem[address][31:0];
    end
  end

endmodule