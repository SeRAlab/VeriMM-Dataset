module top_module( SOC_IN , SOC_OUT , SOC_DIR , FPGA_IN , FPGA_OUT , 
    FPGA_DIR ) ;input  SOC_IN ;
output SOC_OUT ;
output SOC_DIR ;
output FPGA_IN ;
input  FPGA_OUT ;
input  FPGA_DIR ;

assign FPGA_IN = SOC_IN ;
assign SOC_OUT = FPGA_OUT ;
assign SOC_DIR = FPGA_DIR ;endmodule