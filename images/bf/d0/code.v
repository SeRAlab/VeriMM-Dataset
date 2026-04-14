module pit_wb_bus #(parameter ARST_LVL = 1'b0,    
  		    parameter DWIDTH = 16,
                    parameter SINGLE_CYCLE = 1'b0)
  (
  output reg  [DWIDTH-1:0] wb_dat_o,     
  output                   wb_ack_o,     
  input                    wb_clk_i,     
  input                    wb_rst_i,     
  input                    arst_i,       
  input             [ 2:0] wb_adr_i,     
  input       [DWIDTH-1:0] wb_dat_i,     
  input                    wb_we_i,      
  input                    wb_stb_i,     
  input                    wb_cyc_i,     
  input              [1:0] wb_sel_i,     
  output reg        [ 3:0] write_regs,   
  output                   async_rst_b,  
  output                   sync_reset,   
  input                    irq_source,   
  input             [47:0] read_regs     
  );
  reg        bus_wait_state;  
  reg  [2:0] addr_latch;      
  wire       eight_bit_bus;
  wire       module_sel;      
  wire       wb_wacc;         
  wire       wb_racc;         
  wire [2:0] address;         
  assign eight_bit_bus = (DWIDTH == 8);
  assign async_rst_b = arst_i ^ ARST_LVL;
  assign sync_reset = wb_rst_i;
  assign module_sel = wb_cyc_i && wb_stb_i;
  assign wb_wacc    = module_sel && wb_we_i && (wb_ack_o || SINGLE_CYCLE);
  assign wb_racc    = module_sel && !wb_we_i;
  assign wb_ack_o   = SINGLE_CYCLE ? module_sel : (bus_wait_state && module_sel);
  assign address    = SINGLE_CYCLE ? wb_adr_i : addr_latch;
  always @(posedge wb_clk_i or negedge async_rst_b)
    if (!async_rst_b)
      bus_wait_state <=  1'b0;
    else if (sync_reset)
      bus_wait_state <=  1'b0;
    else
      bus_wait_state <=  module_sel && !bus_wait_state;
  always @(posedge wb_clk_i)
    if ( module_sel )                  
      addr_latch <= wb_adr_i;
  always @*
      case ({eight_bit_bus, address}) 
      4'b1_000: wb_dat_o = read_regs[ 7: 0];  
      4'b1_001: wb_dat_o = read_regs[15: 8];  
      4'b1_010: wb_dat_o = read_regs[23:16];  
      4'b1_011: wb_dat_o = read_regs[31:24];  
      4'b1_100: wb_dat_o = read_regs[39:32];  
      4'b1_101: wb_dat_o = read_regs[47:40];  
      4'b0_000: wb_dat_o = read_regs[15: 0];  
      4'b0_001: wb_dat_o = read_regs[31:16];
      4'b0_010: wb_dat_o = read_regs[47:32];
      default:  wb_dat_o = 0;
    endcase
  always @*
    begin
      write_regs = 0;
      if (wb_wacc)
	case ({eight_bit_bus, address}) 
	   4'b1_000 : write_regs = 4'b0001;
	   4'b1_001 : write_regs = 4'b0010;
	   4'b1_010 : write_regs = 4'b0100;
	   4'b1_011 : write_regs = 4'b1000;
	   4'b0_000 : write_regs = 4'b0011;
	   4'b0_001 : write_regs = 4'b1100;
	   default: ;
	endcase
    end
endmodule