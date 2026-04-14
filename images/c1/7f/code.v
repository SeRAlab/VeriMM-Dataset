module gfx_wbm_write (clk_i, rst_i,
                      cyc_o, stb_o, cti_o, bte_o, we_o, adr_o, sel_o, ack_i, err_i, dat_o, sint_o,
                      write_i, ack_o,
                      render_addr_i, render_sel_i, render_dat_i);
  input         clk_i;    
  input         rst_i;    
  output reg    cyc_o;    
  output        stb_o;    
  output [ 2:0] cti_o;    
  output [ 1:0] bte_o;    
  output        we_o;     
  output [31:0] adr_o;    
  output [ 3:0] sel_o;    
  input         ack_i;    
  input         err_i;    
  output [31:0] dat_o;    
  output        sint_o;     
  input         write_i;
  output reg    ack_o;
  input [31:2]  render_addr_i;
  input [ 3:0]  render_sel_i;
  input [31:0]  render_dat_i;
  assign adr_o  = {render_addr_i, 2'b00};
  assign dat_o  = render_dat_i;
  assign sel_o  = render_sel_i;
  assign sint_o = err_i;
  assign we_o   = 1'b1;
  assign stb_o  = 1'b1;
  assign cti_o  = 3'b000;
  assign bte_o  = 2'b00;
  always @(posedge clk_i or posedge rst_i)
  begin
    if(rst_i)
    begin
      ack_o <= 1'b0;
      cyc_o <= 1'b0;
    end
    else
    begin
      cyc_o <= ack_i   ? 1'b0 : 
               write_i ? 1'b1 :
               cyc_o;
      ack_o <= ack_i; 
    end
  end
endmodule