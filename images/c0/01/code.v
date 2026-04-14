module cop_wb_bus #(parameter ARST_LVL = 1'b0,    
  		    parameter DWIDTH = 16,
                    parameter SINGLE_CYCLE = 1'b0)
  (
  output      [DWIDTH-1:0] wb_dat_o,     
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
  output reg        [ 4:0] write_regs,   
  output                   async_rst_b,  
  output                   sync_reset,   
  input                    irq_source,   
  input             [47:0] read_regs     
  );
  reg                bus_wait_state;  
  reg  [DWIDTH-1:0]  rd_data_mux;     
  reg  [DWIDTH-1:0]  rd_data_reg;     
  wire   eight_bit_bus;
  wire   module_sel;      
  wire   wb_wacc;         
  wire   wb_racc;         
  assign eight_bit_bus = (DWIDTH == 8);
  assign async_rst_b = arst_i ^ ARST_LVL;
  assign sync_reset = wb_rst_i;
  assign module_sel = wb_cyc_i && wb_stb_i;
  assign wb_wacc    = module_sel && wb_we_i && (wb_ack_o || SINGLE_CYCLE);
  assign wb_racc    = module_sel && !wb_we_i;
  assign wb_ack_o   = SINGLE_CYCLE ? module_sel : ( module_sel && bus_wait_state);
  assign wb_dat_o   = SINGLE_CYCLE ? rd_data_mux : rd_data_reg;
  always @(posedge wb_clk_i or negedge async_rst_b)
    if (!async_rst_b)
      bus_wait_state <=  1'b0;
    else if (sync_reset)
      bus_wait_state <=  1'b0;
    else
      bus_wait_state <=  module_sel && !bus_wait_state;
  always @(posedge wb_clk_i)
    if ( wb_racc )                     
      rd_data_reg <= rd_data_mux;
  always @*
      case ({eight_bit_bus, wb_adr_i}) 
	4'b1_000: rd_data_mux = read_regs[ 7: 0];  
	4'b1_001: rd_data_mux = read_regs[15: 8];  
	4'b1_010: rd_data_mux = read_regs[23:16];  
	4'b1_011: rd_data_mux = read_regs[31:24];  
	4'b1_100: rd_data_mux = read_regs[39:32];  
	4'b1_101: rd_data_mux = read_regs[47:40];  
	4'b0_000: rd_data_mux = read_regs[15: 0];  
	4'b0_001: rd_data_mux = read_regs[31:16];
	4'b0_010: rd_data_mux = read_regs[47:32];
      endcase
  always @*
    begin
      write_regs = 0;
      if (wb_wacc)
	case ({eight_bit_bus, wb_adr_i}) 
	   5'b1_000 : write_regs = 5'b00001;
	   5'b1_001 : write_regs = 5'b00010;
	   5'b1_010 : write_regs = 5'b00100;
	   5'b1_011 : write_regs = 5'b01000;
	   5'b1_100 : write_regs = 5'b10000;
	   5'b0_000 : write_regs = 5'b00011;
	   5'b0_001 : write_regs = 5'b01100;
	   5'b0_010 : write_regs = 5'b10000;
	   default: ;
	endcase
    end
endmodule